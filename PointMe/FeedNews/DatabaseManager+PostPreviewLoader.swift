import Foundation
import Firebase
import UIKit

extension DatabaseManager {
    public func getDataPosts(completion: @escaping (Result<[PostPreviewModel], Error>) -> Void) {
        let dispatchGroup: DispatchGroup = DispatchGroup()
        let lock: NSLock = NSLock()
        
        var arrayPosts: [PostPreviewModel] = []
        
        let reference: DatabaseReference = Database.database().reference()
        
        let currentUID = "GPPDuOVlTBQo7wtxpJeVc5ZAWro2" // "Ffk5GXb4ohZsUGtXaT30wonM21K3"
        
        reference.child("users").child(currentUID).child("publishers").getData { error, snapshot in
            guard error == nil else {
                completion(.failure(FeedNewsError.loadDataError))
                return
            }
            
            guard let publishersArray = snapshot.value as? [String] else {
                completion(.failure(FeedNewsError.loadDataError))
                return
            }
            
            reference.child("posts").getData { error, snapshot in
                guard error == nil else {
                    print("debug: error reference.child('posts').getData")
                    completion(.failure(FeedNewsError.loadDataError))
                    return
                }
                
                guard let arrayPostsData = snapshot.value as? [String : Any] else {
                    print("debug: arrayPostsData = snapshot.value")
                    completion(.failure(FeedNewsError.loadDataError))
                    return
                }
                
                for postData in arrayPostsData {
                    guard let dictPosts = postData.value as? [String : Any], let userUID = dictPosts["uid"] as? String, userUID != currentUID, publishersArray.contains(userUID) else {
                        continue
                    }
                    
                    dispatchGroup.enter()
                    DatabaseManager.shared.fetchUserData(uid: dictPosts["uid"] as? String ?? "") { result in
                        switch result {
                        case .success(let userData):
                            let keyPreviewImage = (dictPosts["keysImages"] as? [String] ?? []).first ?? ""
                            dispatchGroup.enter()
                            DatabaseManager.shared.fetchImagePreviewData(idImage: keyPreviewImage) { result in
                                var tempDataImage: Data? = nil
                                lock.lock()
                                switch result {
                                case .success(let dataPreviewImage):
                                    tempDataImage = dataPreviewImage
                                    break
                                case .failure(_):
                                    break
                                }
                                arrayPosts.append(PostPreviewModel(
                                    uid: dictPosts["uid"] as? String ?? "",
                                    postId: postData.key,
                                    username: userData.username,
                                    postDateDay: dictPosts["day"] as? Int ?? 1,
                                    postDateMonth: dictPosts["mounth"] as? Int ?? 1,
                                    postDateYear: dictPosts["year"] as? Int ?? 2021,
                                    postImage: tempDataImage,
                                    avatarData: userData.avatarData,
                                    keysImages: dictPosts["keysImages"] as? [String] ?? [],
                                    countImages: (dictPosts["keysImages"] as? [String] ?? []).count,
                                    title: dictPosts["title"] as? String ?? "",
                                    comment: dictPosts["comment"] as? String ?? "",
                                    location: dictPosts["address"] as? String ?? "",
                                    mark: dictPosts["mark"] as? Int ?? 1
                                ))
                                lock.unlock()
                                dispatchGroup.leave()
                            }
                            break
                        case .failure(_):
                            break
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    print("debug: its all array \(arrayPosts)")
                    completion(.success(arrayPosts))
                }
            }
        }
    }
    
    func fetchUserData(uid: String, completion: @escaping (Result<UserPreviewModel, Error>) -> Void) {
        let reference: DatabaseReference = Database.database().reference()
        let storage: StorageReference = Storage.storage().reference()
        
        reference.child("users").child(uid).getData { error, snapshot in
            guard error == nil else {
                completion(.failure(FeedNewsError.loadDataError))
                return
            }
            
            guard let dictUserData = snapshot.value as? [String : Any] else {
                completion(.failure(FeedNewsError.loadDataError))
                return
            }
            
            guard let avatarPath = dictUserData["avatar"] as? String else {
                completion(.failure(FeedNewsError.loadDataError))
                return
            }
            
            storage.child("avatars").child(avatarPath).getData(maxSize: 1024 * 1024 * 15) { data, error in
                guard error == nil else {
                    //completion(.failure(FeedNewsError.loadDataError))
                    completion(.success(UserPreviewModel(username: dictUserData["username"] as? String ?? "", avatarData: nil)))
                    return
                }
                
                completion(.success(UserPreviewModel(username: dictUserData["username"] as? String ?? "", avatarData: data)))
                return
            }
            
            
            
        }
    
    }
    
    
    func fetchImagePreviewData(idImage: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        let storage: StorageReference = Storage.storage().reference()
        print("posts/\(idImage)")
        storage.child("posts").child(idImage).getData(maxSize: 1024 * 1024 * 15) { data, error in
            guard error == nil else {
                
                completion(.failure(FeedNewsError.loadDataError))
                return
            }
            
            completion(.success(data))
        }
    }
    
    
    //                    let postModel = PostModel(
    //                        uid: userUID,
    //                        title: dictPosts["title"] as? String ?? "",
    //                        latitude: dictPosts["latitude"] as? Double ??  55.751574,
    //                        longitude: dictPosts["longitude"] as? Double ??  55.751574,
    //                        address: dictPosts["address"] as? String ?? "",
    //                        comment: dictPosts["comment"] as? String ?? "",
    //                        keysImages: dictPosts["keysImages"] as? [String] ?? [],
    //                        day: dictPosts["day"] as? Int ?? 1,
    //                        month: dictPosts["mounth"] as? Int ?? 1,
    //                        year: dictPosts["year"] as? Int ?? 2021,
    //                        mark: dictPosts["mark"] as? Int ?? 1
    //                    )
    
    /*public func getPosts(publishers: [String], completion: @escaping (Result<[PostPreviewModel], Error>) -> Void) {
        let reference: DatabaseReference = Database.database().reference()
        var posts: [PostPreviewModel] = []
        //let storage: StorageReference = Storage.storage().reference()
        //let currentUserID = "Ffk5GXb4ohZsUGtXaT30wonM21K3"
        print(321)
        reference.child("posts").getData { error, snapshot in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(FeedNewsError.loadDataError))
                }
                return
            }
            print(444)
            for postData in snapshot.value  as! [String: AnyObject] {
                let onePostData = postData.value as! [String: AnyObject]
                let userUID = onePostData["uid"] as! String
                print(5, onePostData["uid"] as! String)
                print(6, publishers)
                if publishers.contains(userUID) {
                    
                    reference.child("users").child(userUID).getData { error, userSnapshot in
                        print(999)
                        guard error == nil else {
                            DispatchQueue.main.async {
                                completion(.failure(FeedNewsError.loadDataError))
                            }
                            return
                        }
                        
                        guard let userInfoArray = userSnapshot.value as? [String: AnyObject] else {
                            DispatchQueue.main.async {
                                completion(.failure(FeedNewsError.loadDataError))
                            }
                            return
                        }
                            
                        let publicationInfo = PostPreviewModel(avatarImage: userInfoArray["avatar"] as! String,
                                                               username: userInfoArray["username"] as! String,
                                                               postDateDay: onePostData["day"] as! Int,
                                                               postDateMonth: onePostData["month"] as! Int,
                                                               postDateYear: onePostData["year"] as! Int,
                                                               postImage: onePostData["keysImages"] as! [String],
                                                               title: onePostData["title"] as! String,
                                                               location: onePostData["address"] as! String,
                                                               mark: onePostData["mark"] as! Int)
                        
                        posts.append(publicationInfo)
                        print(8, posts.count)
                    }
                    
                }
                
            }
            DispatchQueue.main.async {
                completion(.success(posts))
            }
            
            
        }
    }
    
    public func getPostImage(imageKey: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        //let reference: DatabaseReference = Database.database().reference()
        let storage: StorageReference = Storage.storage().reference()
        //var posts: [PostPreviewModel] = []
        //let storage: StorageReference = Storage.storage().reference()
        //let currentUserID = "Ffk5GXb4ohZsUGtXaT30wonM21K3"
        storage.child("posts").child(imageKey).getData(maxSize: 1024 * 1024 * 100) { data, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(FeedNewsError.loadDataError))
                }
                return
            }
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                completion(.success(image!))
            }
            
        }
    }
}*/
}
