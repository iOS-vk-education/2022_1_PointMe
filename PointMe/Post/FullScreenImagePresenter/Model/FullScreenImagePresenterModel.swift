import Foundation


final class FullScreenImagePresenterModel {
    
    private var arrayImageData: [Data?] = []
    
    init() {}
    
    func setImageData(imageData: [Data?]) {
        arrayImageData = imageData
    }
    
    func getImageData(index: Int) -> Data? {
        return arrayImageData[index]
    }
    
    public var countData: Int {
        get {
            arrayImageData.count
        }
    }
}
