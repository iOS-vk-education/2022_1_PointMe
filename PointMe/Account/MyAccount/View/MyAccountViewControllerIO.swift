import Foundation


protocol MyAccountViewControllerInput: AnyObject {
    func reloadTableView(accountInfo: MyAccountInfo, accountPosts: [MyAccountPost])
}

protocol MyAccountViewControllerOutput: AnyObject {
    func userWantsToViewMyAccountInfo()
    func userWantsToRemovePost(postKey: String, postKeys: [String], imageKey: [String])
}
