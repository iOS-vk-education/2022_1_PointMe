import Foundation


struct UserModel {
    var uid: String
    var email: String
    var password: String
    var username: String
    var avatar: String?
    var countSubscribers: Int = 0
    var countPublishers: Int = 0
    var publishers: [String] = []
    var posts: [String] = []
    var favourite: [String] = []
    
    init(uid: String, email: String, password: String, username: String, avatar: String?) {
        self.uid = uid
        self.email = email
        self.password = password
        self.username = username
        self.avatar = avatar
    }
}
