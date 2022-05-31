import Foundation
import Firebase

extension DatabaseManager {
    func getDataPosts4Map(completion: @escaping (Result<[PostData4Map], Error>) -> Void) {
        guard let currentUID = DatabaseManager.shared.currentUserUID else {
            completion(.failure(NSError()))
            return
        }
        
        var resultArray: [PostData4Map] = [PostData4Map]()
        
        let reference: DatabaseReference = Database.database().reference()
        
        reference.child("posts").getData { error, snapshot in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(FeedNewsError.loadDataError))
                }
                return
            }
            
            guard let data = snapshot.value as? [String : Any] else {
                DispatchQueue.main.async {
                    completion(.failure(FeedNewsError.loadDataError))
                }
                return
            }
            
            for key in data.keys {
                guard let postData = data[key] as? [String : Any],
                      let uidPostUser = postData["uid"] as? String,
                      uidPostUser != currentUID
                else {
                    continue
                }
                
                resultArray.append(
                    PostData4Map(
                        idPost: key,
                        keysImages: postData["keysImages"] as? [String] ?? [],
                        latitude: postData["latitude"] as? Double ?? 55.751574,
                        longitude: postData["longitude"] as? Double ?? 37.573856,
                        username: postData["username"] as? String ?? "",
                        dateDay: postData["day"] as? Int ?? 1,
                        dateMonth: postData["month"] as? Int ?? 1,
                        dateYear: postData["year"] as? Int ?? 2022,
                        title: postData["title"] as? String ?? "",
                        comment: postData["comment"] as? String ?? "",
                        mark: postData["mark"] as? Int ?? 1,
                        uid: postData["uid"] as? String ?? ""
                    )
                )
            }
            
            DispatchQueue.main.async {
                completion(.success(resultArray))
            }
        }
    }
    
    func getAvatar(userId: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        let storage = Storage.storage().reference()
        let reference: DatabaseReference = Database.database().reference()
        
        reference.child("users").child(userId).child("avatar").getData { error, snapshot in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(FeedNewsError.loadDataError))
                }
                return
            }
            
            let avatarPath: String = snapshot.value as? String ?? ""
            
            storage.child("avatars").child(avatarPath).getData(maxSize: 1024 * 1024 * 100) { data, error in
                if let error = error {
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
    }
}
