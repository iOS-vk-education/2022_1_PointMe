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
        
        addPost(postData: postModel) { [weak self] result in
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
    
    
    public func addPost(
        postData: PostModel,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        let newReference = Database.database().reference()
        let newStorage = Storage.storage().reference()
        
        guard let keyPost = newReference.child("posts").childByAutoId().key else {
            completion(.failure(AddPostError.serverError))
            return
        }
        
        let keysImages: [String] = postData.keysImages.map { _ in
            UUID().uuidString
        }
        
        let data: [String: Any] = [
            "uid" : postData.uid,
            "title" : postData.title,
            "latitude" : postData.latitude,
            "longitude" : postData.longitude,
            "address" : postData.address,
            "comment" : postData.comment,
            "keysImages" : keysImages,
            "day" : postData.day,
            "month" : postData.month,
            "year" : postData.year,
            "mark" : postData.mark
        ]
        
        newReference.child("posts").child(keyPost).setValue(data) { error, _ in
            guard error == nil else {
                completion(.failure(AddPostError.serverError))
                return
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            for indexPost in (0 ..< keysImages.count) {
                guard let dataImage = try? Data(contentsOf: postData.keysImages[indexPost]) else {
                    completion(.failure(AddPostError.serverError))
                    return
                }
                
                newStorage.child("posts").child(keysImages[indexPost]).putData(dataImage, metadata: metadata) { metadata, error in
                    guard error == nil else {
                        completion(.failure(AddPostError.serverError))
                        return
                    }
                }
            }
            
            newReference.child("users").child(postData.uid).child("posts").getData { error, snapshot in
                guard error == nil else {
                    completion(.failure(AddPostError.serverError))
                    return
                }
                
                var arrayPosts = snapshot.value as? [String] ?? Array<String>()
                arrayPosts.append(keyPost)
                
                newReference.child("users").child(postData.uid).child("posts").setValue(arrayPosts) { error, _ in
                    guard error == nil else {
                        completion(.failure(AddPostError.serverError))
                        return
                    }
                }
            }
            completion(.success(Void()))
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
