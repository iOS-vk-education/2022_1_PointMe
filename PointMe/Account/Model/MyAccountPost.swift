import Foundation
import Firebase

struct MyAccountPost {
    
    var userImage: String
    var userImageData: Data?
    var userName: String
    
    var comment: String
    var date: MyAccountPostDate
    
    var images: [String]
    var mainImage: Data?
    var numberOfImages: Int
    
    var mainTitle: String
    var address: String
    
    var mark: Int
    
    init(userName: String, userImage: String, snapshot: DataSnapshot)
    {
        let snapshotValue = snapshot.value as? [String : AnyObject]
        
        self.userImage = userImage
        self.userName = userName
        
        self.comment = snapshotValue?["comment"] as? String ?? ""
        date = MyAccountPostDate(day: snapshotValue?["day"] as? Int ?? 1,
                                 month: snapshotValue?["month"] as? Int ?? 1,
                                 year: snapshotValue?["year"] as? Int ?? 2000)
        images = snapshotValue?["keysImages"] as? [String] ?? [""]
        numberOfImages = images.count
        if (images[0] == "") {
            numberOfImages = 0
        } else {
            numberOfImages = images.count
        }
        
        mainTitle = snapshotValue?["title"] as? String ?? ""
        address = snapshotValue?["address"] as? String ?? ""
        
        mark = snapshotValue?["mark"] as? Int ?? 0
    }
    
    init(userImage: String = "",
         userName: String = "",
         comment: String = "",
         date: MyAccountPostDate = .init(day: 0, month: 0, year: 0),
         mainImage: [String] = [""],
         numberOfImages: Int = 0,
         mainTitle: String = "",
         address: String = "",
         mark: Int = 0) {
        self.userImage = userImage
        self.userName = userName
        self.comment = comment
        self.date = date
        
        self.images = mainImage
        self.numberOfImages = numberOfImages
        
        self.mainTitle = mainTitle
        self.address = address
        
        self.mark = mark
    }
}
