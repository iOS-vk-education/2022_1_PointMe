import Foundation
import Firebase
import UIKit

extension DatabaseManager {
    public func getFollowedPublishers(completion: @escaping (Result<[String], Error>) -> Void) {
        print(567)
        let reference: DatabaseReference = Database.database().reference()
        //let storage: StorageReference = Storage.storage().reference()
        //let currentUserID = "Ffk5GXb4ohZsUGtXaT30wonM21K3"
        reference.child("users").child("GPPDuOVlTBQo7wtxpJeVc5ZAWro2").child("publishers").getData { error, snapshot in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(FeedNewsError.loadDataError))
                }
                return
            }
            
            guard let publishersArray = snapshot.value as? [String] else {
                DispatchQueue.main.async {
                    completion(.failure(FeedNewsError.loadDataError))
                }
                return
            }
            
            /*
            reference.child("posts").getData { error, snapshot in
                guard error == nil else {
                    completion(.failure(FeedNewsError.loadDataError))
                    return
                }
                
                for postData in snapshot.children {
                    print(1, postData)
                }
            }
             */
            
            //print("array: \(publishersArray)")
            DispatchQueue.main.async {
                print(987, publishersArray)
                completion(.success(publishersArray))
            }

        }
    }
    
    public func getPosts(publishers: [String], completion: @escaping (Result<[PostPreviewModel], Error>) -> Void) {
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
}
