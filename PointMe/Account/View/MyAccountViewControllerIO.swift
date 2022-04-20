import Foundation


protocol MyAccountViewControllerInput: AnyObject {
    func reloadTableView()
}

protocol MyAccountViewControllerOutput: AnyObject {
    func userWantsToViewAccountInfo(completion: @escaping (MyAccountInfo) -> Void)
    func userWantsToViewAccountPosts(userName: String, userImage: String, postKey: String, completion: @escaping (MyAccountPost) -> Void)
    func userWantsToViewImage(destination: String, postImageKey: String, completion: @escaping (Data) -> Void)
    func userWantsToRemovePost(postKeys: [String], imageKey: String)
}
