import Firebase

final class MyAccountNetwork {
    
    weak var presenter: MyAccountPresenter?
}

extension MyAccountNetwork: MyAccountModelInput {
    func removePostfromDatabase(postKeys: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.removePostFromUserPosts(postKeys: postKeys) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success():
                completion(.success(Void()))
            }
        }
    }
    
    func removePostFromPosts(postKey: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.removePostFromPosts(postKey: postKey) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success():
                completion(.success(Void()))
            }
        }
    }
    
    func removeImageFromStorage(imageKey: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.removeImageFromStorage(imageKey: imageKey) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success():
                completion(.success(Void()))
            }
        }
    }
    
    func getAccountInfoData(completion: @escaping (MyAccountInfo) -> Void) {
        DatabaseManager.shared.getMyAccountInfo() { result in
            switch result {
            case .failure(let error):
                print("Error getAccountInfoData \(error)")
            case .success(let myAccountInfo):
                completion(myAccountInfo)
            }
        }
    }
    
    func getAccountPostData(userName: String, userImage: String, postKey: String, completion: @escaping (MyAccountPost) -> Void) {
        DatabaseManager.shared.getMyAccountPosts(userName: userName, userImage: userImage, postKey: postKey) { result in
            switch result {
            case .failure(let error):
                print("Error getAccountPostsData \(error)")
            case .success(let myAccountPost):
                completion(myAccountPost)
            }
        }
    }
    
    func getImage(destination: String, postImageKey: String, completion: @escaping (Data) -> Void) {
        DatabaseManager.shared.getImage(destination: destination, postImageKey: postImageKey) { result in
            switch result {
            case .failure(let error):
                print("Error getPostImages \(error)")
            case .success(let data):
                completion(data)
            }
        }
    }
}
