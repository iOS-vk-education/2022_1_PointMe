import Foundation
import Firebase


final class CreatingPostModel: SimpleLogger {
    static var nameClassLogger: String = "CreatingPostModel"
    private var arrayOfImagesURL: [URL] = []
    private var arrayOfImageData: [Data] = []
    private var markValue: Int = 0
    private var address: String?
    private var location: (latitude: Double, longitude: Double)?
    
    init() {}
    
    var locationTuple: (latitude: Double, longitude: Double)? {
        return location
    }
    
    public func getImageData(by index: Int) -> Data {
        return arrayOfImageData[index]
    }
    
    public func appendImageData(in data: Data) {
        arrayOfImageData.append(data)
    }
    
    public func removeImage(by index: Int) {
        arrayOfImageData.remove(at: index)
    }
    
    public var countImage: Int {
        get {
            arrayOfImageData.count
        }
    }
    
    public func updateMark(mark value: Int) {
        markValue = value
    }
    
    public func appendLocation(location: (latitude: Double, longitude: Double)) {
        self.location = location
    }
    
    public func appendAddress(value: String) {
        address = value
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
        let urlsStringImages: [String] = arrayOfImageData.map { _ in
            UUID().uuidString
        }
        
        let postModel: PostModel = PostModel(
            uid: userId,
            title: title,
            latitude: location?.latitude ?? 55.751574,
            longitude: location?.longitude ?? 37.573856,
            address: address ?? "Неизвестный адрес",
            comment: comment,
            keysImages: urlsStringImages,
            day: date.day,
            month: date.mounth,
            year: date.year,
            mark: markValue
        )
        
        DatabaseManager.shared.addPost(postData: postModel, imagesData: arrayOfImageData) { [weak self] result in
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
    
    public func fetchAddress(latitude: Double, longitude: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        if address != nil{
            completion(.success(Void()))
            return
        }

        GeocoderManager.shared.loadDataPlaceBy(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let data):
                self?.appendAddress(value: data)
                print("\(#function) \(data)")
                completion(.success(Void()))
            case .failure(let error):
                self?.appendAddress(value: "Неизвестный адрес")
                print("\(#function) error fetch addr")
                completion(.failure(error))
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
        
        print("debug: date = \(mounth)")
        return (day: day, mounth: mounth, year: year)
    }
}
