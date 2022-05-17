import UIKit

final class MyAccountPresenter {
    weak var view: MyAccountViewControllerInput?
    var model: MyAccountModelInput?
}

// MARK: - MyAccountModelOutput

extension MyAccountPresenter: MyAccountModelOutput {
    func reloadOutdatedInfo() {

    }
}

// MARK: - MyAccountViewControllerOutput

extension MyAccountPresenter: MyAccountViewControllerOutput {

    func userWantsToRemovePost(postKey: String, postKeys: [String], imageKey: [String]) {
        model?.removePostfromDatabase(postKeys: postKeys) { result in
            switch result {
            case .failure(let error):
                print("Holy cow removePostfromDatabase not done! (\(error))")
            case .success():
                print("removePostfromDatabase successfully done")
            }
        }
        for i in 0..<imageKey.count {
            if (imageKey[i] != "") {
                model?.removeImageFromStorage(imageKey: imageKey[i]) { result in
                    switch result {
                    case .failure(let error):
                        print("Holy cow removeImageFromStorage not done! (\(error))")
                    case .success():
                        print("removeImageFromStorage successfully done")
                    }
                }
            }
            model?.removePostFromPosts(postKey: postKey) { result in
                switch result {
                case .failure(let error):
                    print("Holy cow removePostFromPosts not done! (\(error))")
                case .success():
                    print("removePostFromPosts successfully done")
                }
            }
        }
    }
    
    func userWantsToViewMyAccountInfo() {
        model?.getAccountInfoData() {[weak self] data in
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
}
