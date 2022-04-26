import Foundation


protocol MyAccountViewControllerInput: AnyObject {
    func reloadTableView()
}

protocol MyAccountViewControllerOutput: AnyObject {
    func userWantsToViewMyAccountInfo(completion: @escaping (MyAccountInfo, [MyAccountPost]) -> Void)
    func userWantsToRemovePost(postKey: String, postKeys: [String], imageKey: [String])
}
