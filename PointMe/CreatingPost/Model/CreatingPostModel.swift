import Foundation


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
    
    public func addPost(title: String?, comment: String?, completion: @escaping (AuthResult) -> Void) {
        guard let title = title, let comment = comment else {
            completion(.failure(NSError()))
            return
        }
        
        guard let userId = DatabaseManager.shared.currentUserUID else {
            completion(.failure(NSError()))
            return
        }
        
        let postModel: PostModel = PostModel(
            uid: userId,
            title: title,
            // MARK: FIX ME!!! Исправить хардкод
            latitude: 55.751574,
            // MARK: FIX ME!!! Исправить хардкод
            longitude: 37.573856,
            // MARK: FIX ME!!! Исправить хардкод
            address: "test, address",
            comment: comment,
            keysImages: arrayOfImagesURL,
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
                completion(.success)
                break
            }
        }
    }
}
