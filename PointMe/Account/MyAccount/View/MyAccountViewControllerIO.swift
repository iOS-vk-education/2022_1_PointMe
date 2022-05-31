import Foundation


protocol MyAccountViewControllerInput: AnyObject {
    func reloadTableView(accountInfo: MyAccountInfo, accountPosts: [MyAccountPost])
    func openSettings()
}

protocol MyAccountViewControllerOutput: AnyObject {
    func userWantsToViewMyAccountInfo()
    func userWantsToRemovePost(postKey: String, postKeys: [String], imageKey: [String])
    func userWantsToEditProfile()
}
