import Foundation

struct PostPreviewModel {
        
    let dates: [Int: String] = [
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
    
    var avatarImage: String
    var username: String
    var postDate: String
    var postImage: [String]
    var numberOfImages: Int
    var title: String
    var location: String
    var mark: Int
    
    init(avatarImage: String, username: String, postDateDay: Int, postDateMonth: Int, postDateYear: Int, postImage: [String], title: String, location: String, mark: Int) {
        self.avatarImage = avatarImage
        self.username = username
        self.postDate = String(postDateDay) + dates[postDateMonth]! + String(postDateYear) + " года"
        self.postImage = postImage
        self.numberOfImages = postImage.count
        self.title = title
        self.location = location
        self.mark = mark
    }
    
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
