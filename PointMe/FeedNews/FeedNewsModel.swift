import Foundation

class FeedNewsModel {
    
    
    //var posts: [PostPreviewModel] = [
    //    PostPreviewModel(avatarImage: nil, username: "username1", postDate: "17 апреля 2022 года", postImage: "star.square", //numberOfImages: 2, title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor", //location: "СолнцеЛокация", mark: 5),
    //    PostPreviewModel(avatarImage: "person.circle.fill", username: "username2", postDate: "17 апреля 2022 года", postImage: //nil, numberOfImages: 0, title: "Ut enim ad minim veniam, quis nostrud exercitation ullamco", location: //"ВенераЛокация", mark: 4),
    //    PostPreviewModel(avatarImage: nil, username: "username3", postDate: "17 апреля 2022 года", postImage: "star.square", //numberOfImages: 3, title: "Duis aute irure dolor in reprehenderit", location: "ЗемляЛокация", mark: 5),
    //    PostPreviewModel(avatarImage: nil, username: "username4", postDate: "17 апреля 2022 года", postImage: "star.square", //numberOfImages: 1, title: "Excepteur sint occaecat cupidatat non proident", location: "СатурнЛокация", mark: 3),
    //    PostPreviewModel(avatarImage: "person.circle.fill", username: "username5", postDate: "17 апреля 2022 года", postImage: //nil, numberOfImages: 0, title: "Sunt in culpa qui officia deserunt", location: "ЮпитерЛокация", mark: 2)
    //]
    
    
    var posts: [PostPreviewModel] = []
    var publishers: [String] = []
    
    func getPosts() {
        
        
        
        DatabaseManager.shared.getFollowedPublishers() { result in
            switch result {
            case .success(let publishersArray):
                print(9, publishersArray)
                self.publishers = publishersArray
                break
            case .failure(let error):
                break
            }
            
        }
        DatabaseManager.shared.getPosts(publishers: publishers) { result in
            switch result {
            case .success(let data):
                self.posts = data
                break
            case .failure(let error):
                break
            }
        }
    }
    
    
    
}
