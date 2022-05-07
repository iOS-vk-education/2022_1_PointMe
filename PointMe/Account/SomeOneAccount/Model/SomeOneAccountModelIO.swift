import Foundation
import Firebase

protocol SomeOneAccountModelInput: AnyObject {
    func getAccountInfoData(uid: String?, completion: @escaping (MyAccountInfo) -> Void)
    func getAccountPostData(userName: String, userImage: String, postKey: String, completion: @escaping (MyAccountPost) -> Void)
    func getImage(destination: String, postImageKey: String, completion: @escaping (Data) -> Void)
    func makeSubscriber(uid: String, completion: @escaping (Result<Void, Error>) -> Void)
    func dismissSubscribe(uid: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getUserPublishers(uid: String?, completion: @escaping (DataSnapshot) -> Void)
}

protocol SomeOneAccountModelOutput: AnyObject {
    func reloadOutdatedInfo()
}
