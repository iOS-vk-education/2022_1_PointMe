import Foundation


protocol SomeOneAccountViewControllerInput: AnyObject {
    func reloadTableView(accountInfo: MyAccountInfo, accountPosts: [MyAccountPost])
    func fetchSubscription(isSubscribed: Bool)
}

protocol SomeOneAccountViewControllerOutput: AnyObject {
    func userWantsToViewAccountInfo(uid: String)
    func userWantsToBecomeSubscribe(uid: String)
    func userWantsToDismissSubscribe(uid: String)
    func userWantsToCheckSubscription(destinationUID: String)
}
