import Foundation

struct FindUserData {
    let uid: String
    let username: String
    let avatarPath: String
}

final class FindUserModel {
    
    private var userDataArray: [FindUserData] = [FindUserData]()
    
    private var filtredUserDataArray: [FindUserData] = [FindUserData]()
    
    private var dataUsersImages: [String : Data?] = [:]
    
    init() {}
    
    func fetchData(completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.getUsersDataForFind { result in
            switch result {
            case .success(let data):
                self.userDataArray = data
                let group = DispatchGroup()
                let lock = NSLock()
                
                for info in self.userDataArray {
                    group.enter()
                    DatabaseManager.shared.getUserAvatarForFind(postImageKey: info.avatarPath) { result in
                        switch result {
                        case .success(let dataImage):
                            lock.lock()
                            self.dataUsersImages[info.uid] = dataImage
                            lock.unlock()
                        case .failure(_):
                            lock.lock()
                            self.dataUsersImages[info.uid] = nil
                            lock.unlock()
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(Void()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func filterUserDataBySearchText(searchText: String) {
        filtredUserDataArray = userDataArray.filter {
            $0.username.lowercased().contains(searchText.lowercased())
        }
    }
    
    public func getUserDataByIndex(index: Int, isFiltered: Bool) -> FindUserCellContext {
        return isFiltered ?
            FindUserCellContext(
                uid: filtredUserDataArray[index].uid,
                username: filtredUserDataArray[index].username,
                imageData: dataUsersImages[filtredUserDataArray[index].uid] as? Data
            ) : FindUserCellContext(
                uid: userDataArray[index].uid,
                username: userDataArray[index].username,
                imageData: dataUsersImages[userDataArray[index].uid] as? Data
            )
    }
    
    public var countUsersData: Int {
        get {
            return userDataArray.count
        }
    }
    
    public var countFilteredUsersData: Int {
        get {
            return filtredUserDataArray.count
        }
    }
    
    public func getUserDataTupleByIndex(index: Int, isFiltered: Bool) -> (uid: String, username: String, imageData: Data?) {
        return isFiltered ? (
            filtredUserDataArray[index].uid,
            filtredUserDataArray[index].username,
            dataUsersImages[filtredUserDataArray[index].uid] as? Data
        ) : (
            uid: userDataArray[index].uid,
            username: userDataArray[index].username,
            imageData: dataUsersImages[userDataArray[index].uid] as? Data
        )
    }
}
