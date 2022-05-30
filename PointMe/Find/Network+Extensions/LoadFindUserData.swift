import Foundation
import Firebase

extension DatabaseManager {
    public func getUsersDataForFind(completion: @escaping (Result<[FindUserData], Error>) -> Void) {
        let reference: DatabaseReference = Database.database().reference()
        var arrayUserDataForFind: [FindUserData] = [FindUserData]()
        
        reference.child("users").getData { error, snapshot in
            guard error == nil else {
                completion(.failure(AddPostError.serverError))
                return
            }
            
            guard let data = snapshot.value as? [String : Any] else {
                completion(.failure(AddPostError.unknownError))
                return
            }
            
            for key in data.keys.sorted() {
                guard key != DatabaseManager.shared.currentUserUID,
                      let curUserData = data[key] as? [String : Any] else {
                    continue
                }
                
                arrayUserDataForFind.append(FindUserData(
                    uid: key,
                    username: curUserData["username"] as? String ?? "",
                    avatarPath: curUserData["avatar"] as? String ?? ""
                ))
            }
            
            completion(.success(arrayUserDataForFind))
        }
    }
    
    
    public func getUserAvatarForFind(postImageKey: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let storage: StorageReference = Storage.storage().reference()
        
        storage.child("avatars").child(postImageKey).getData(maxSize: 1024 * 1024 * 100) { data, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
    }
}
