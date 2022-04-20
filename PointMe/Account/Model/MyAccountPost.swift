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
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
        self.userImage = userImage
        self.userName = userName
        
        self.comment = snapshotValue["comment"] as! String
        date = MyAccountPostDate(day: snapshotValue["day"] as! Int, month: snapshotValue["month"] as! Int, year: snapshotValue["year"] as! Int)
        if let strongImages = (snapshotValue["keysImages"] as? [String]) {
            images = strongImages
            numberOfImages = images.count
        } else {
            images = [""]
            numberOfImages = 0
        }
        
        mainTitle = snapshotValue["title"] as! String
        address = snapshotValue["address"] as! String
        
        mark = snapshotValue["mark"] as! Int
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
