import Foundation
import Firebase


final class DatabaseManager {
    static let shared: DatabaseManager = DatabaseManager()
    
    private var reference: DatabaseReference!
    private var storage: StorageReference!
    
    private init() {
        storage = Storage.storage().reference()
        reference = Database.database().reference()
    }
    
    public var currentUserUID: String? {
        get {
            Auth.auth().currentUser?.uid
        }
    }
    
    public func getMyAccountInfo(completion: @escaping (Result<MyAccountInfo, Error>) -> Void) {
        let strongCurrentUserUID = "Ffk5GXb4ohZsUGtXaT30wonM21K3"
        
        reference.child("users").child(strongCurrentUserUID).getData() { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            let accountInfo = MyAccountInfo(snapshot: snapshot)
            DispatchQueue.main.async {
                completion(.success(accountInfo))
            }
        }
    }
    
    public func getMyAccountPosts(userName: String, userImage: String, postKey: String, completion: @escaping (Result<MyAccountPost, Error>) -> Void) {
        
        reference.child("posts").child(postKey).getData() { error, snapshot in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            let accountPost = MyAccountPost(userName: userName, userImage: userImage, snapshot: snapshot)
            DispatchQueue.main.async {
                completion(.success(accountPost))
            }
        }
    }
    
    public func removePostFromDatabase(postKeys: [String], completion: @escaping (Result <Void, Error>) -> Void) {
        reference.child("users").child("Ffk5GXb4ohZsUGtXaT30wonM21K3").child("posts").setValue(postKeys) { error, _ in
            guard error == nil else {
                completion(.failure(NSError()))
                return
            }
        }
    }
    
    
    public func removeImageFromStorage(imageKey: String, completion: @escaping (Result <Void, Error>) -> Void) {
        storage.child("posts").child(imageKey).delete { error in
            guard error == nil else {
                completion(.failure(NSError()))
                return
            }
        }
    }
    
    public func getImage(destination: String, postImageKey: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        storage.child(destination).child(postImageKey).getData(maxSize: 1024 * 1024 * 100) { data, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            if let data = data {
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            }
        }
    }
    
    
    public func addPost(postData: PostModel, completion: ((AuthResult) -> Void)?) {
        guard let keyPost = reference.child("posts").childByAutoId().key else {
            completion?(.failure(NSError()))
            return
        }
        
        let keysImages: [String] = postData.keysImages.map { _ in
            UUID().uuidString
        }
        
        let data: [String: Any] = [
            "uid" : postData.uid,
            "title" : postData.title,
            "latitude" : postData.latitude,
            "longitude" : postData.longitude,
            "address" : postData.address,
            "comment" : postData.comment,
            "keysImages" : keysImages,
            "mark" : postData.mark
        ]
        
        reference.child("posts").child(keyPost).setValue(data) { error, _ in
            guard error == nil else {
                completion?(.failure(NSError()))
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            for indexPost in (0 ..< keysImages.count) {
                guard let dataImage = try? Data(contentsOf: postData.keysImages[indexPost]) else {
                    completion?(.failure(NSError()))
                    return
                }
                
                self.storage.child("posts").child(keysImages[indexPost]).putData(dataImage, metadata: metadata) { metadata, error in
                    guard error == nil else {
                        completion?(.failure(NSError()))
                        return
                    }
                }
            }
            
            
            self.reference.child("users").child(postData.uid).child("posts").getData { error, snapshot in
                guard error == nil else {
                    print(error!.localizedDescription)
                    completion?(.failure(NSError()))
                    return
                }
                
                var arrayPosts = snapshot.value as? [String] ?? Array<String>()
                arrayPosts.append(keyPost)
                
                self.reference.child("users").child(postData.uid).child("posts").setValue(arrayPosts) { error, _ in
                    guard error == nil else {
                        completion?(.failure(NSError()))
                        return
                    }
                }
            }
            
            completion?(.success)
        }
    }
    
    public func addUser(userData: UserModel, completion: ((AuthResult) -> Void)?) {
        let data: [String: Any] = [
            "uid" : userData.uid,
            "username" : userData.username,
            "email" : userData.email,
            "password" : userData.password,
            "avatar" : userData.avatar ?? "",
            "subscribers" : 0,
            "publishers": [],
            "posts" : [],
            "favourite" : []
        ]
        
        reference.child("users").child(userData.uid).setValue(data) { error, _ in
            guard error == nil else {
                completion?(.failure(NSError()))
                return
            }
            
            completion?(.success)
        }
    }
}

extension DatabaseManager {
    struct Constants {
        static let numberOfPostsBlock: Int = 5
        
    }
}
