import Firebase

final class MyAccountNetwork {
    
    weak var presenter: MyAccountPresenter!
}

extension MyAccountNetwork: MyAccountModelInput {
    func removePostfromDatabase(postKeys: [String]) {
        DatabaseManager.shared.removePostFromDatabase(postKeys: postKeys) { result in
            switch result {
            case .failure(let error):
                print("Error removePost \(error)")
            case .success():
                break
            }
        }
    }
    
    func removeImageFromStorage(imageKey: String) {
        DatabaseManager.shared.removeImageFromStorage(imageKey: imageKey) { result in
            switch result {
            case .failure(let error):
                print("Error removePost \(error)")
            case .success():
                break
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
