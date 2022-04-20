import Foundation

struct UserPreviewModel {
    var username: String
    var avatarData: Data?
    
    init(username: String, avatarData: Data?) {
        self.username = username
        self.avatarData = avatarData
    }
}

final class PostPreviewCellModel {
    
    private var userPreviewModel: UserPreviewModel?
    private var imageData: Data? = nil
    
    func fetchUserData(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.fetchUserData(uid: uid) { result in
            switch result {
            case .success(let res):
                self.userPreviewModel = res
                completion(.success(Void()))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    func fetchImageData(idImage: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DatabaseManager.shared.fetchImagePreviewData(idImage: idImage) { result in
            switch result {
            case .success(let res):
                self.imageData = res
                completion(.success(Void()))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    var username: String {
        get {
            userPreviewModel?.username ?? ""
        }
    }
    
    var avatarData: Data? {
        get {
            userPreviewModel?.avatarData
        }
    }
    
    var imagePreview: Data? {
        get {
            imageData
        }
    }
    
}
