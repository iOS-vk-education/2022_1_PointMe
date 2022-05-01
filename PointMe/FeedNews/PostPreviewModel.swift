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
    var username: String
    var postImage: Data?
    var avatarData: Data?
    var keysImages: [String]
    var numberOfImages: Int
    var title: String
    var comment: String
    var location: String
    var postDateDay: Int
    var postDateMonth: Int
    var postDateYear: Int
    var mark: Int
    
    init(uid: String,
         postId: String,
         username: String,
         postDateDay: Int,
         postDateMonth: Int,
         postDateYear: Int,
         postImage: Data?,
         avatarData: Data?,
         keysImages: [String],
         countImages: Int,
         title: String,
         comment: String,
         location: String,
         mark: Int) {
        self.uid = uid
        self.postId = postId
        self.postDateDay = postDateDay
        self.postDateMonth = postDateMonth
        self.postDateYear = postDateYear
        self.postImage = postImage
        self.numberOfImages = countImages
        self.title = title
        self.location = location
        self.mark = mark
        self.keysImages = keysImages
        self.avatarData = avatarData
        self.comment = comment
        self.username = username
    }
        
    var postDate: String {
        get {
            String(postDateDay) + dates[postDateMonth]! + String(postDateYear) + " года"
        }
    }
}
