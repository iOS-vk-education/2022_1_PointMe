import Firebase

struct MyAccountInfo {
    
    let userName: String
    let userImageKey: String
    var userImage: Data?
    
    var postKeys: [String]
    
    let numberOfSubscribers: Int
    let numberOfSubscriptions: Int
    
    init(snapshot: DataSnapshot) {
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
            numberOfSubscriptions = strongValue.count
        } else {
            numberOfSubscriptions = 0
        }
    }
    
    init(userName: String = "", userImageKey: String = "", postKeys: [String] = [""], numberOfSubscribers: Int = 0, numberOfSubscriptions: Int = 0) {
        self.userName = userName
        self.userImageKey = userImageKey
        
        self.postKeys = postKeys
        
        self.numberOfSubscribers = numberOfSubscribers
        self.numberOfSubscriptions = numberOfSubscriptions
    }
}
