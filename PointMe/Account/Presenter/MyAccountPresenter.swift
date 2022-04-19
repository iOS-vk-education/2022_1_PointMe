import UIKit

final class MyAccountPresenter {
    weak var view: MyAccountViewControllerInput!
    var model: MyAccountModelInput!
}

extension MyAccountPresenter: MyAccountModelOutput {
    func reloadOutdatedInfo() {

    }
}

extension MyAccountPresenter: MyAccountViewControllerOutput {
    

    func userWantsToViewAccountInfo(completion: @escaping (MyAccountInfo) -> Void) {
        model.getAccountInfoData(completion: completion)
    }
    
    func userWantsToViewAccountPosts(userName: String, userImage: String, postKey: String, completion: @escaping (MyAccountPost) -> Void) {
        model.getAccountPostData(userName: userName, userImage: userImage, postKey: postKey, completion: completion)
    }
    
    func userWantsToViewImage(destination: String, postImageKey: String, completion: @escaping (Data) -> Void) {
        model.getImage(destination: destination, postImageKey: postImageKey, completion: completion)
    }
    
}
