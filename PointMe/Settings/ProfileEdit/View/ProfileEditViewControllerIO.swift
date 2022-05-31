import Foundation

protocol ProfileEditViewControllerInput: AnyObject {
    func makeAlert(forTitleText: String, forBodyText: String)
    func fetchInfo(username: String, email: String, image: Data?, imageKey: String)
}

protocol ProfileEditViewControllerOutput: AnyObject {
    func changeInfo(username: String?, email: String?, avatar: Data?, avatarKey: String)
    func getInfo()
}
