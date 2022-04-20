import Foundation

final class PostViewControllerModel {
    
    private let dates: [Int: String] = [
        1: " января ",
        2: " февраля ",
        3: " марта ",
        4: " апреля ",
        5: " мая ",
        6: " июня ",
        7: " июля ",
        8: " августа ",
        9: " сентября ",
        10: " октября ",
        11: " ноября ",
        12: " декабря "
    ]
    
    private var arrayDataImages: [String] = []
    private var avatarData: Data? = nil
    private var dataArray: [Data?] = []
    private var usernameValue: String = "Username"
    private var dateVlaue: String = "12 мая 2022 года"
    private var titleValue: String = "Лучшее место на земле"
    private var isChartPostValue: Bool = false
    private var markValue: Int = 3
    private var commentTextValue: String = "Здесь было хорошо! Вкусная еда, добрые люди, отличная музыка."
    
    init() {}
    
    func fetchData(context: PostContext, completion: @escaping (Result<Void, Error>) -> Void) {
        usernameValue = context.username
        dateVlaue = String(context.dateDay) + dates[context.dateMonth]! + String(context.dateYear) + " года"
        titleValue = context.title
        markValue = context.mark
        commentTextValue = context.comment
        avatarData = context.avatarImage
        arrayDataImages = context.keysImages
        avatarData = context.avatarImage
        print("debug: \(usernameValue), \(dateVlaue), \(titleValue)")
        
        let group = DispatchGroup()
        let lock = NSLock()
        
        for key in arrayDataImages {
            group.enter()
            DatabaseManager.shared.getImage(destination: "posts", postImageKey: key) { result in
                switch result {
                case .success(let data):
                    lock.lock()
                    self.dataArray.append(data)
                    print("debug: add data")
                    lock.unlock()
                    break
                case .failure(_):
                    break
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("debug: its all")
            completion(.success(Void()))
        }
    }
    
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
    
    public var avatar: Data? {
        get {
            avatarData
        }
    }
    
    public func toggleChartPost() {
        isChartPostValue.toggle()
    }
    
    public var isImagesExist: Bool {
        get {
            print("debug: isImagesExist \(arrayDataImages)")
            guard arrayDataImages.count != 0, (arrayDataImages.first ?? "") != "" else {
                print("debug: isImagesExist return false")
                return false
            }
            print("debug: isImagesExist return true")
            return true//arrayDataImages.count != 0
        }
    }
    
    public var countDataImages: Int {
        get {
            dataArray.count
        }
    }
    
    public func sendDataImages() -> [Data?] {
        return dataArray
    }
    
    public func getDataImageByIndex(index: Int) -> Data? {
        return dataArray[index]
    }
}
