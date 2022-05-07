import UIKit
import Firebase

final class SomeOneAccountPresenter {
    weak var view: SomeOneAccountViewControllerInput!
    var model: SomeOneAccountModelInput!
}

// MARK: - MyAccountModelOutput

extension SomeOneAccountPresenter: SomeOneAccountModelOutput {
    func reloadOutdatedInfo() {

    }
}

// MARK: - MyAccountViewControllerOutput

extension SomeOneAccountPresenter: SomeOneAccountViewControllerOutput {
    
    func userWantsToCheckSubscription(uid: String?, destinationUID: String, completion: @escaping (Bool) -> Void) {
        model.getUserPublishers(uid: DatabaseManager.shared.currentUserUID) { snapshot in
            let snapshotValue = snapshot.value as? [String]
            var flag = false
            snapshotValue?.forEach() {
                if (destinationUID == $0) {
                    flag = true
                }
            }
            completion(flag)
        }
    }

    func userWantsToViewAccountInfo(uid: String?, completion: @escaping (MyAccountInfo, [MyAccountPost]) -> Void)
    {
        model.getAccountInfoData(uid: uid) {[weak self] data in
            guard let strongSelf = self else { return }
            let group = DispatchGroup()
            let lock = NSLock()
            
            let myAccountInfo = data
            var myAccountPosts: [MyAccountPost] = []
            
            group.enter()

            if (myAccountInfo.postKeys != [""]) {
                for i in 0..<myAccountInfo.postKeys.count {
                    group.enter()
                    strongSelf.model.getAccountPostData(userName: myAccountInfo.userName,
                                                        userImage: myAccountInfo.userImageKey,
                                                        postKey: myAccountInfo.postKeys[i]) { post in
                        lock.lock()
                        myAccountPosts.insert(post, at: i)
                        lock.unlock()
                        if (post.images[0] != "") {
                            strongSelf.model.getImage(destination: "posts",postImageKey: post.images[0]) { dataImage in
                                lock.lock()
                                myAccountPosts[i].mainImage = dataImage
                                lock.unlock()
                                group.leave()
                            }
                        } else {
                            group.leave()
                        }
                    }
                }
            }
            group.leave()
            group.notify(queue: .main) {
                completion(myAccountInfo, myAccountPosts)
            }
        }
    }
    
    func userWantsToBecomeSubscribe(uid: String) {
        model.makeSubscriber(uid: uid) { result in
            switch result {
            case .failure(let error):
                print("Failed to become subscriber \(error)")
            case .success():
                break
            }
        }
    }
    
    func userWantsToDismissSubscribe(uid: String) {
        model.dismissSubscribe(uid: uid){ result in
            switch result {
            case .failure(let error):
                print("Failed to become subscriber \(error)")
            case .success():
                break
            }
        }
    }
}

// testuser1@gmail.com
