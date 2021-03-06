import Foundation
import Firebase
import UIKit

extension DatabaseManager {
    public func removeListener(withHandle handle: UInt) {
        let reference: DatabaseReference = Database.database().reference()
        
        guard let currentUID = DatabaseManager.shared.currentUserUID else {
            return
        }
        
        reference.child("users").child(currentUID).child("favourite").removeObserver(withHandle: handle)
    }
    
    public func startCreateListenerFavoritePosts(comletion: @escaping (UInt) -> Void) {
        let lock: NSLock = NSLock()
        
        let reference: DatabaseReference = Database.database().reference()
        guard let currentUID = DatabaseManager.shared.currentUserUID else { return }
        
        let handler = reference.child("users").child(currentUID).child("favourite").observe(DataEventType.childAdded) { snapshot in
            guard let idPost = snapshot.value as? String else { return }
            
            reference.child("posts").child(idPost).getData { error, postSnapshot in
                guard let dictPosts = postSnapshot.value as? [String : Any] else { return }
                
                DatabaseManager.shared.fetchUserData(uid: dictPosts["uid"] as? String ?? "") { result in
                    switch result {
                    case .success(let userData):
                        let keyPreviewImage = (dictPosts["keysImages"] as? [String] ?? []).first ?? ""
                        DatabaseManager.shared.fetchImagePreviewData(idImage: keyPreviewImage) { result in
                            var tempDataImage: Data? = nil
                            switch result {
                            case .success(let dataPreviewImage):
                                tempDataImage = dataPreviewImage
                            case .failure(_):
                                break
                            }
                            lock.lock()
                            DatabaseManager.shared.favoritesPostsManager?.addPost(post: PostPreviewModel(
                                uid: dictPosts["uid"] as? String ?? "",
                                postId: idPost,
                                username: userData.username,
                                postDateDay: dictPosts["day"] as? Int ?? 1,
                                postDateMonth: dictPosts["month"] as? Int ?? 1,
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
                            DispatchQueue.main.async {
                                DatabaseManager.shared.favoritesPostsManager?.notifySuccessLoading()
                            }
                        }
                    case .failure(_):
                        break
                    }
                }
            }
        }
        
        comletion(handler)
    }
    
    public func startRemoveListenerFavoritePosts(comletion: @escaping (UInt) -> Void) {
        let lock: NSLock = NSLock()
        let reference: DatabaseReference = Database.database().reference()
        guard let currentUID = DatabaseManager.shared.currentUserUID else { return }
        
        let handler = reference.child("users").child(currentUID).child("favourite").observe(DataEventType.childRemoved) { snapshot in
            guard let idPost = snapshot.value as? String else { return }
            
            lock.lock()
            DatabaseManager.shared.favoritesPostsManager?.removePost(by: idPost)
            lock.unlock()
            DispatchQueue.main.async {
                DatabaseManager.shared.favoritesPostsManager?.notifySuccessLoading()
            }
        }
        
        comletion(handler)
    }
    
    public func getDataFavoritePosts(completion: @escaping (Result<[PostPreviewModel], Error>) -> Void) {
        let dispatchGroup: DispatchGroup = DispatchGroup()
        let lock: NSLock = NSLock()
        
        var arrayPosts: [PostPreviewModel] = []
        
        let reference: DatabaseReference = Database.database().reference()
        
        //"GPPDuOVlTBQo7wtxpJeVc5ZAWro2" // "Ffk5GXb4ohZsUGtXaT30wonM21K3"
        guard let currentUID = DatabaseManager.shared.currentUserUID else {
            completion(.failure(FeedNewsError.loadDataError))
            return
        }
        
        reference.child("users").child(currentUID).child("favourite").getData { error, snapshot in
            guard error == nil else {
                completion(.failure(FeedNewsError.loadDataError))
                return
            }
            
            guard let favouritesArray = snapshot.value as? [String] else {
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
                    guard let dictPosts = postData.value as? [String : Any], favouritesArray.contains(postData.key) else {
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
                                    postDateMonth: dictPosts["month"] as? Int ?? 1,
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
                    completion(.success(arrayPosts))
                }
            }
        }
    }
}
