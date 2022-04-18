import Foundation
import Firebase


final class CreatingPostModel: SimpleLogger {
    static var nameClassLogger: String = "CreatingPostModel"
    private var arrayOfImagesURL: [URL] = []
    private var markValue: Int = 0
    
    init() {}
    
    public func getImageURL(for index: Int) -> URL {
        return arrayOfImagesURL[index]
    }
    
    public func appendURL(url value: URL) {
        arrayOfImagesURL.append(value)
    }
    
    public func removeByIndexURL(for index: Int) {
        arrayOfImagesURL.remove(at: index)
    }
    
    public var countImage: Int {
        get {
            arrayOfImagesURL.count
        }
    }
    
    public func updateMark(mark value: Int) {
        markValue = value
    }
    
    public func addPost(title: String?, comment: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let title = title, let comment = comment, title != "", comment != "", comment != "Оставьте комментарий", markValue != 0 else {
            completion(.failure(AddPostError.invalidDataError))
            return
        }
        
        guard let userId = DatabaseManager.shared.currentUserUID else {
            completion(.failure(AddPostError.serverError))
            return
        }
        
        let date = getCurrentDate()
        
        let postModel: PostModel = PostModel(
            uid: userId,
            title: title,
            // FIX ME!!! Исправить хардкод
            latitude: 55.751574,
            // FIX ME!!! Исправить хардкод
            longitude: 37.573856,
            // FIX ME!!! Исправить хардкод
            address: "test, address",
            comment: comment,
            keysImages: arrayOfImagesURL,
            day: date.day,
            month: date.mounth,
            year: date.year,
            mark: markValue
        )
        
        DatabaseManager.shared.addPost(postData: postModel) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.log(message: "Error create a post")
                completion(.failure(error))
                break
            case .success:
                self?.log(message: "Success create a post")
                completion(.success(Void()))
                break
            }
        }
    }
}


private extension CreatingPostModel {
    func getCurrentDate() -> (day: Int, mounth: Int, year: Int) {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)

        guard let day = components.day, let mounth = components.month, let year = components.year else {
            return (day: 1, mounth: 1, year: 2022)
        }
        
        return (day: day, mounth: mounth, year: year)
    }
}
