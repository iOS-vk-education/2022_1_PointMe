import Foundation

protocol MyAccountModelInput: AnyObject {
    func getAccountInfoData(completion: @escaping (MyAccountInfo) -> Void)
    func getAccountPostData(userName: String, userImage: String, postKey: String, completion: @escaping (MyAccountPost) -> Void)
    func getImage(destination: String, postImageKey: String, completion: @escaping (Data) -> Void)
    func removePostfromDatabase(postKeys: [String])
    func removeImageFromStorage(imageKey: String)
}

protocol MyAccountModelOutput: AnyObject {
    func reloadOutdatedInfo()
}
