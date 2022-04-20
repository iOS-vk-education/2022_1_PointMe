import Foundation
import Firebase


final class DatabaseManager {
    static let shared: DatabaseManager = DatabaseManager()
    
    private var reference: DatabaseReference!
    private var storage: StorageReference!
    private var infoReference: DatabaseReference!
    
    private init() {
        storage = Storage.storage().reference()
        reference = Database.database().reference()
        infoReference = Database.database().reference(withPath: ".info/connected")
    }
    
    public var currentUserUID: String? {
        get {
            Auth.auth().currentUser?.uid
        }
    }
    
    public func addPost(postData: PostModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let keyPost = reference.child("posts").childByAutoId().key else {
            completion(.failure(AddPostError.serverError))
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
            "day" : postData.day,
            "month" : postData.month,
            "year" : postData.year,
            "mark" : postData.mark
        ]
        
        reference.child("posts").child(keyPost).setValue(data) { [weak self] error, _ in
            guard let self = self else {
                completion(.failure(AddPostError.unknownError))
                return
            }
            
            guard error == nil else {
                completion(.failure(AddPostError.serverError))
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            for indexPost in (0 ..< keysImages.count) {
                guard let url = URL(string: postData.keysImages[indexPost]), let dataImage = try? Data(contentsOf: url) else {
                    completion(.failure(AddPostError.serverError))
                    return
                }
                
                self.storage.child("posts").child(keysImages[indexPost]).putData(dataImage, metadata: metadata) { metadata, error in
                    guard error == nil else {
                        completion(.failure(AddPostError.serverError))
                        return
                    }
                }
            }
            
            self.reference.child("users").child(postData.uid).child("posts").getData { error, snapshot in
                guard error == nil else {
                    completion(.failure(AddPostError.serverError))
                    return
                }
                
                var arrayPosts = snapshot.value as? [String] ?? Array<String>()
                arrayPosts.append(keyPost)
                
                self.reference.child("users").child(postData.uid).child("posts").setValue(arrayPosts) { error, _ in
                    guard error == nil else {
                        completion(.failure(AddPostError.serverError))
                        return
                    }
                }
            }
            completion(.success(Void()))
        }
    }
    
    public func addUser(userData: UserModel, completion: ((Result<Void, Error>) -> Void)?) {
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
            
            completion?(.success(Void()))
        }
    }
        
}
