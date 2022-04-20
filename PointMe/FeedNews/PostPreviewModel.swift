import Foundation

struct PostPreviewModel {
    
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
    
    var uid: String
    var postId: String
    //var postDate: String
    var postImage: String
    var numberOfImages: Int
    var title: String
    var location: String
    var postDateDay: Int
    var postDateMonth: Int
    var postDateYear: Int
    var mark: Int
    
    init(uid: String, postId: String, postDateDay: Int, postDateMonth: Int, postDateYear: Int, postImage: String, countImages: Int, title: String, location: String, mark: Int) {
        self.uid = uid
        self.postId = postId
        self.postDateDay = postDateDay
        self.postDateMonth = postDateMonth
        self.postDateYear = postDateYear
        //self.postDate = String(postDateDay) + dates[postDateMonth]! + String(postDateYear) + " года"
        self.postImage = postImage
        self.numberOfImages = countImages
        self.title = title
        self.location = location
        self.mark = mark
    }
    
//    let avatarImage = avatarImage
//    self.username = username
//    self.postDate = String(postDateDay) + dates[postDateMonth]! + String(postDateYear) + " года"
//    self.postImage = postImage
//    self.numberOfImages = postImage.count
//    self.title = title
//    self.location = location
//    self.mark = mark
    
//    init(username: String, postModel: PostModel, previewImageData: Data?) {
//        self.postModel = postModel
//        self.previewImageData = previewImageData
//        self.username = username
//    }
        
    var postDate: String {
        get {
            String(postDateDay) + dates[postDateMonth]! + String(postDateYear) + " года"
        }
    }
//
//    var avatarImage: String
//    var username: String
//    var postDate: String
//    var postImage: [String]
//    var numberOfImages: Int
//    var title: String
//    var location: String
//    var mark: Int
//
//    init(avatarImage: String, username: String, postDateDay: Int, postDateMonth: Int, postDateYear: Int, postImage: [String], title: String, location: String, mark: Int) {
//        self.avatarImage = avatarImage
//        self.username = username
//        self.postDate = String(postDateDay) + dates[postDateMonth]! + String(postDateYear) + " года"
//        self.postImage = postImage
//        self.numberOfImages = postImage.count
//        self.title = title
//        self.location = location
//        self.mark = mark
//    }
    
    //internal init(avatarImage: String? = nil, username: String, postDate: String, postImage: String? = nil, numberOfImages: //Int? = nil, title: String, location: String, mark: Int) {
    //    self.avatarImage = avatarImage
    //    self.username = username
    //    self.postDate = postDate
    //    self.postImage = postImage
    //    self.numberOfImages = numberOfImages
    //    self.title = title
    //    self.location = location
    //    self.mark = mark
    //}
}
