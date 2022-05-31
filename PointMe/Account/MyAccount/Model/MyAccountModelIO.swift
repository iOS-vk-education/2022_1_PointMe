import Foundation

protocol MyAccountModelInput: AnyObject {
    func getAccountInfoData(completion: @escaping (MyAccountInfo) -> Void)
    func getAccountPostData(userName: String, userImage: String, postKey: String, completion: @escaping (MyAccountPost) -> Void)
    func getImage(destination: String, postImageKey: String, completion: @escaping (Data) -> Void)
    func removePostfromDatabase(postKeys: [String], completion: @escaping (Result<Void, Error>) -> Void)
    func removePostFromPosts(postKey: String, completion: @escaping (Result<Void, Error>) -> Void)
    func removeImageFromStorage(imageKey: String, completion: @escaping (Result<Void, Error>) -> Void)
    func removePostFromFavorites(postKey: String, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol MyAccountModelOutput: AnyObject {
    func reloadOutdatedInfo()
}
