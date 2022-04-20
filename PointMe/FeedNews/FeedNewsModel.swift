import Foundation

class FeedNewsModel {
    
    private var posts: [PostPreviewModel] = []
    
    func getPosts(completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.getDataPosts { result in
            switch result {
            case .success(let postsArray):
                print(9, postsArray)
                self.posts = postsArray
                print("debug: self.posts = \(self.posts)")
                completion(.success(Void()))
                break
            case .failure(let error):
                print("debug: error getPosts")
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
        return posts[index].postImage != ""
    }
    
}
