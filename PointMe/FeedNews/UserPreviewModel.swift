import Foundation

struct UserPreviewModel {
    var username: String
    var avatarData: Data?
    
    init(username: String, avatarData: Data?) {
        self.username = username
        self.avatarData = avatarData
    }
}
