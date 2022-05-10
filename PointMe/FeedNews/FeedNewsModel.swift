import Foundation
import UIKit

class FeedNewsModel {
    
    private var posts: [PostPreviewModel] = []
    
    func getPosts(completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.getDataPosts { [weak self] result in
            switch result {
            case .success(let postsArray):
                print(9, postsArray)
                self?.posts = postsArray
                print("debug: self.posts = \(String(describing: self?.posts))")
                completion(.success(Void()))
                break
            case .failure(let error):
                print("debug: error getPosts")
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
