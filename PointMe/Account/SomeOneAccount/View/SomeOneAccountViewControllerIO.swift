import Foundation


protocol SomeOneAccountViewControllerInput: AnyObject {
    func reloadTableView()
}

protocol SomeOneAccountViewControllerOutput: AnyObject {
    func userWantsToViewAccountInfo(uid: String, completion: @escaping (MyAccountInfo, [MyAccountPost]) -> Void)
    func userWantsToBecomeSubscribe(uid: String)
    func userWantsToDismissSubscribe(uid: String)
    func userWantsToCheckSubscription(destinationUID: String, completion: @escaping (Bool) -> Void)
}
