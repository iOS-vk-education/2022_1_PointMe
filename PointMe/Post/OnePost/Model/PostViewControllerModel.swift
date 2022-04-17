import Foundation

final class PostViewControllerModel {
    
    private var arrayDataImages: [String] = [
        "1photo",
        "2photo",
        "3photo",
        "4photo"
    ]
    
    private let usernameValue: String = "Username"
    private let dateVlaue: String = "12 мая 2022 года"
    private let titleValue: String = "Лучшее место на земле"
    private var isChartPostValue: Bool = false
    private let markValue: Int = 3
    private let commentTextValue: String = "Здесь было хорошо! Вкусная еда, добрые люди, отличная музыка."
    
    init() {}
    
    public var username: String {
        get {
            usernameValue
        }
    }
    
    public var date: String {
        get {
            dateVlaue
        }
    }
    
    public var title: String {
        get {
            titleValue
        }
    }
    
    public var mark: Int {
        get {
            markValue
        }
    }
    
    public var commentText: String {
        get {
            commentTextValue
        }
    }
    
    public var isChartPost: Bool {
        get {
            isChartPostValue
        }
    }
    
    public func toggleChartPost() {
        isChartPostValue.toggle()
    }
    
    public var isImagesExist: Bool {
        get {
            arrayDataImages.count != 0
        }
    }
    
    public var countDataImages: Int {
        get {
            arrayDataImages.count
        }
    }
    
    public func sendDataImages() -> [String] {
        return arrayDataImages
    }
    
    public func getDataImageByIndex(index: Int) -> String {
        return arrayDataImages[index]
    }
}
