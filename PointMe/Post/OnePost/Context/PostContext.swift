import Foundation


struct PostContext {
    let idPost: String
    let keysImages: [String]
    let avatarImage: Data?
    let username: String
    let dateDay: Int
    let dateMonth: Int
    let dateYear: Int
    let title: String
    let comment: String
    let mark: Int
    let uid: String
    
    init(contextWithoutAvatar: PostContextWithoutAvatar, avatar: Data?) {
        idPost = contextWithoutAvatar.idPost
        keysImages = contextWithoutAvatar.keysImages
        username = contextWithoutAvatar.username
        dateDay = contextWithoutAvatar.dateDay
        dateMonth = contextWithoutAvatar.dateMonth
        dateYear = contextWithoutAvatar.dateYear
        title = contextWithoutAvatar.title
        comment = contextWithoutAvatar.comment
        mark = contextWithoutAvatar.mark
        uid = contextWithoutAvatar.uid
        avatarImage = avatar
    }
    
    init(
        idPost: String,
        keysImages: [String],
        avatarImage: Data?,
        username: String,
        dateDay: Int,
        dateMonth: Int,
        dateYear: Int,
        title: String,
        comment: String,
        mark: Int,
        uid: String
    ) {
        self.idPost = idPost
        self.keysImages = keysImages
        self.username = username
        self.dateDay = dateDay
        self.dateMonth = dateMonth
        self.dateYear = dateYear
        self.title = title
        self.comment = comment
        self.mark = mark
        self.uid = uid
        self.avatarImage = avatarImage
    }
}

struct PostContextWithoutAvatar {
    let idPost: String
    let keysImages: [String]
    let username: String
    let dateDay: Int
    let dateMonth: Int
    let dateYear: Int
    let title: String
    let comment: String
    let mark: Int
    let uid: String
}
