import Firebase

final class MyAccountNetwork {
    
    weak var presenter: MyAccountPresenter?
}

extension MyAccountNetwork: MyAccountModelInput {
    func removePostfromDatabase(postKeys: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.removePostFromUserPosts(postKeys: postKeys) { result in
            completion(result)
        }
    }
    
    func removePostFromPosts(postKey: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.removePostFromPosts(postKey: postKey) { result in
            completion(result)
        }
    }
    
    func removeImageFromStorage(imageKey: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.removeImageFromStorage(imageKey: imageKey) { result in
            completion(result)
        }
    }
    
    func getAccountInfoData(completion: @escaping (MyAccountInfo) -> Void) {
        guard let strongUID = DatabaseManager.shared.currentUserUID else {
            print("no currentUserID")
            return
        }
        DatabaseManager.shared.getAccountInfo(uid: strongUID) { result in
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
        DatabaseManager.shared.getImage(destination: destination, imageKey: postImageKey) { result in
            switch result {
            case .failure(let error):
                print("Error getPostImages \(error)")
            case .success(let data):
                completion(data)
            }
        }
    }
}
