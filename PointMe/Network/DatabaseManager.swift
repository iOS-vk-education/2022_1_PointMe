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
    
    public func addPost(postData: PostModel, completion: ((Result<Void, Error>) -> Void)?) {
        
        let newReference = Database.database().reference()
        var newStorage = Storage.storage().reference()
        
        guard let keyPost = newReference.child("posts").childByAutoId().key else {
            completion?(.failure(AddPostError.serverError))
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
        
        newReference.child("posts").child(keyPost).setValue(data) { error, _ in
            guard error == nil else {
                completion?(.failure(AddPostError.serverError))
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            for indexPost in (0 ..< keysImages.count) {
                guard let dataImage = try? Data(contentsOf: postData.keysImages[indexPost]) else {
                    completion?(.failure(AddPostError.serverError))
                    return
                }
                
                newStorage.child("posts").child(keysImages[indexPost]).putData(dataImage, metadata: metadata) { metadata, error in
                    guard error == nil else {
                        completion?(.failure(AddPostError.serverError))
                        return
                    }
                }
            }
            
            newReference.child("users").child(postData.uid).child("posts").getData { error, snapshot in
                guard error == nil else {
                    completion?(.failure(AddPostError.serverError))
                    return
                }
                
                var arrayPosts = snapshot.value as? [String] ?? Array<String>()
                arrayPosts.append(keyPost)
                
                newReference.child("users").child(postData.uid).child("posts").setValue(arrayPosts) { error, _ in
                    guard error == nil else {
                        completion?(.failure(AddPostError.serverError))
                        return
                    }
                }
            }
            completion?(.success(Void()))
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
