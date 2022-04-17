import Foundation


final class FullScreenImagePresenterModel {
    
    private var arrayImageData: [String] = []
    
    init() {}
    
    func setImageData(imageData: [String]) {
        arrayImageData = imageData
    }
    
    func getImageData(index: Int) -> String {
        return arrayImageData[index]
    }
    
    public var countData: Int {
        get {
            arrayImageData.count
        }
    }
}
