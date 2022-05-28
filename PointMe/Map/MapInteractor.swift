import Foundation

final class MapInteractor {
	weak var output: MapInteractorOutput?
    var postsData: [PostData4Map] = []
}

extension MapInteractor: MapInteractorInput {
    func getPostsData(by arrayIndex: [Int]) -> [PostData4Map] {
        return arrayIndex.map {
            postsData[$0]
        }
    }
    
    func getUid4Post(by index: Int) -> String {
        return postsData[index].uid
    }
    
    func fetchAvatar4Post(by index: Int) {
        
        output?.notifyPostContext(context: PostContextWithoutAvatar(
            idPost: self.postsData[index].idPost,
            keysImages: self.postsData[index].keysImages,
            username: self.postsData[index].username,
            dateDay: self.postsData[index].dateDay,
            dateMonth: self.postsData[index].dateMonth,
            dateYear: self.postsData[index].dateYear,
            title: self.postsData[index].title,
            comment: self.postsData[index].comment,
            mark: self.postsData[index].mark,
            uid: self.postsData[index].uid
        ))
    }
    
    func getMapObj(by index: Int) -> (latitude: Double, longitude: Double) {
        let mapObj: PostData4Map = postsData[index]
        return (latitude: mapObj.latitude, longitude: mapObj.longitude)
    }
    
    var countMapObjs: Int {
        return postsData.count
    }
    
    func fetchMapData() {
        DatabaseManager.shared.getDataPosts4Map { [weak self] result in
            switch result {
            case .success(let data):
                print("success map data load")
                self?.postsData = data
                self?.output?.notifyMapData(isSuccess: true)
            case .failure(_):
                print("\nerror map data load!\n")
                self?.output?.notifyMapData(isSuccess: false)
            }
        }
    }
}
