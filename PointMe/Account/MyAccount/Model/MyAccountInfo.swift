import Firebase

struct MyAccountInfo {
    
    var uid: String
    
    let userName: String
    let email: String?
    let password: String?
    let userImageKey: String
    var userImage: Data?
    
    var postKeys: [String]
    
    let numberOfSubscribers: Int
    let publishers: [String]
    let numberOfSubscriptions: Int
    
    init(snapshot: DataSnapshot, uid: String, confident: Bool) {
        let snapshotValue = snapshot.value as? [String : AnyObject]
        
        userName = snapshotValue?["username"] as? String ?? ""
        userImageKey = snapshotValue?["avatar"] as? String ?? ""
        
        if let strongValue = snapshotValue?["posts"] as? [String] {
            postKeys = strongValue
        } else {
            postKeys = [""]
        }
        
        numberOfSubscribers = snapshotValue?["subscribers"] as? Int ?? 0
        
        if let strongValue = snapshotValue?["publishers"] as? [String] {
            publishers = strongValue
            numberOfSubscriptions = strongValue.count
        } else {
            publishers = [""]
            numberOfSubscriptions = 0
        }
        
        if (confident) {
            self.email = snapshotValue?["email"] as? String
            self.password = snapshotValue?["password"] as? String
        } else {
            self.email = nil
            self.password = nil
        }
        
        self.uid = uid
    }
    
    init(userName: String = "",
         userImageKey: String = "",
         postKeys: [String] = [""],
         numberOfSubscribers: Int = 0,
         numberOfSubscriptions: Int = 0,
         publishers: [String] = [""],
         uid: String = "") {
        self.uid = uid
        self.userName = userName
        self.userImageKey = userImageKey
        
        self.postKeys = postKeys
        
        self.numberOfSubscribers = numberOfSubscribers
        self.publishers = publishers
        self.numberOfSubscriptions = numberOfSubscriptions
        
        self.email = nil
        self.password = nil
    }
}
