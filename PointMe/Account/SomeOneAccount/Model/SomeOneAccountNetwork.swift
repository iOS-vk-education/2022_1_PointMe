import Firebase

final class SomeOneAccountNetwork {
    
    weak var presenter: MyAccountPresenter!
}

extension SomeOneAccountNetwork: SomeOneAccountModelInput {
    
    func getUserPublishers(uid: String, completion: @escaping (DataSnapshot) -> Void) {
        DatabaseManager.shared.getPublishers(uid: uid) { result in
            switch result {
            case .failure(let error):
                print("Error getUserPublishers \(error)")
            case .success(let snapshot):
                completion(snapshot)
            }
        }
    }
    
    func getAccountInfoData(uid: String, completion: @escaping (MyAccountInfo) -> Void) {
        DatabaseManager.shared.getAccountInfo(uid: uid) { result in
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
    
    func makeSubscriber(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.addPublisher(uid: uid) { result in
            completion(result)
        }
        DatabaseManager.shared.increaseSubscribersNumber(uid: uid) { result in
            completion(result)
        }
    }
    
    func dismissSubscribe(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.removePublisher(uid: uid) { result in
            completion(result)
        }
        DatabaseManager.shared.decreaseSubscribersNumber(uid: uid) { result in
            completion(result)
        }
    }
}

