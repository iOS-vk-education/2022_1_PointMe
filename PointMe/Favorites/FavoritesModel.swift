import Foundation
import UIKit

class FavoritesModel {
    
    private var posts: [PostPreviewModel] = []
    private var reloadViewData: (() -> Void)?
    private var handlerAddPost: UInt?
    private var handlerRemovePost: UInt?
    
    deinit {
        print("[DEBUG]: deinit FavoritesModel")
        
        if let handlerAddPost = handlerAddPost {
            DatabaseManager.shared.removeListener(withHandle: handlerAddPost)
        }
        
        if let handlerRemovePost = handlerRemovePost {
            DatabaseManager.shared.removeListener(withHandle: handlerRemovePost)
        }
    }
    
    func setReloadCallback(callback: @escaping () -> Void) {
        reloadViewData = callback
    }
    
    func addFavoritePost(post: PostPreviewModel) {
        posts.append(post)
    }
    
    func removeFavoritePost(id: String) {
        posts = posts.filter {
            $0.postId != id
        }
    }
    
    func notifyView() {
        reloadViewData?()
    }
    
    func startListener() {
        DatabaseManager.shared.favoritesPostsManager?.model = self
        
        DatabaseManager.shared.startCreateListenerFavoritePosts { [weak self] handlerValue in
            self?.handlerAddPost = handlerValue
        }
        
        DatabaseManager.shared.startRemoveListenerFavoritePosts { [weak self] handlerValue in
            self?.handlerRemovePost = handlerValue
        }
    }
    
    func getPosts(completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.getDataFavoritePosts { [weak self] result in
            switch result {
            case .success(let postsArray):
                print(9, postsArray)
                self?.posts = postsArray
                print("debug: self.posts = \(String(describing: self?.posts))")
                completion(.success(Void()))
                break
            case .failure(let error):
                print("debug: error getPosts")
                self?.posts = []
                completion(.failure(error))
                break
            }
        }
    }
    
    func fetchUserData(uid: String, completion: @escaping (Result<UserPreviewModel, Error>) -> Void) {
        DatabaseManager.shared.fetchUserData(uid: uid) { result in
            switch result {
            case .success(let res):
                completion(.success(res))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func fetchImageData(idImage: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        DatabaseManager.shared.fetchImagePreviewData(idImage: idImage) { result in
            switch result {
            case .success(let res):
                completion(.success(res))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    var countPosts: Int {
        get {
            return posts.count
        }
    }
    
    func getPostPreviewModelByIndex(index: Int) -> PostPreviewModel {
        return posts[index]
    }
    
    func checkIsExistImageByIndex(index: Int) -> Bool {
        return posts[index].postImage != nil
    }
    
}
