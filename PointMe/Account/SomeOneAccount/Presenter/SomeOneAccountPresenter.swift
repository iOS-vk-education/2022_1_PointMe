import UIKit
import Firebase

final class SomeOneAccountPresenter {
    weak var view: SomeOneAccountViewControllerInput?
    var model: SomeOneAccountModelInput?
}

// MARK: - MyAccountModelOutput

extension SomeOneAccountPresenter: SomeOneAccountModelOutput {
    func reloadOutdatedInfo() {

    }
}

// MARK: - MyAccountViewControllerOutput

extension SomeOneAccountPresenter: SomeOneAccountViewControllerOutput {
    
    func userWantsToCheckSubscription(destinationUID: String) {
        guard let strongUID = DatabaseManager.shared.currentUserUID else {
            print("debug: No currentUID")
            return
        }
        model?.getUserPublishers(uid: strongUID) { [weak self] snapshot in
            guard let snapshotValue = snapshot.value as? [String] else {
                self?.view?.fetchSubscription(isSubscribed: false)
                return
            }
            self?.view?.fetchSubscription(isSubscribed: snapshotValue.contains(destinationUID))
        }
    }

    func userWantsToViewAccountInfo(uid: String)
    {
        model?.getAccountInfoData(uid: uid) {[weak self] data in
            guard let strongSelf = self else { return }
            let group = DispatchGroup()
            let lock = NSLock()
            
            var myAccountInfo = data
            var myAccountPosts: [MyAccountPost] = []
            
            group.enter()
            
            if(myAccountInfo.userImageKey != "") {
                group.enter()
                strongSelf.model?.getImage(destination: "avatars", postImageKey: myAccountInfo.userImageKey) { dataImage in
                    myAccountInfo.userImage = dataImage
                    group.leave()
                }
            }
            
            if (myAccountInfo.postKeys != [""]) {
                for i in 0..<myAccountInfo.postKeys.count {
                    group.enter()
                    strongSelf.model?.getAccountPostData(userName: myAccountInfo.userName,
                                                        userImage: myAccountInfo.userImageKey,
                                                        postKey: myAccountInfo.postKeys[i]) { post in
                        lock.lock()
                        myAccountPosts.insert(post, at: i)
                        lock.unlock()
                        if (post.images[0] != "") {
                            strongSelf.model?.getImage(destination: "posts",postImageKey: post.images[0]) { dataImage in
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
                strongSelf.view?.reloadTableView(accountInfo: myAccountInfo, accountPosts: myAccountPosts)
            }
        }
    }
    
    func userWantsToBecomeSubscribe(uid: String) {
        model?.makeSubscriber(uid: uid) { result in
            switch result {
            case .failure(let error):
                print("Failed to become subscriber \(error)")
            case .success():
                break
            }
        }
    }
    
    func userWantsToDismissSubscribe(uid: String) {
        model?.dismissSubscribe(uid: uid){ result in
            switch result {
            case .failure(let error):
                print("Failed to become subscriber \(error)")
            case .success():
                break
            }
        }
    }
}
