import Firebase

struct MyAccountInfo {
    
    let userName: String
    let userImageKey: String
    var userImage: Data?
    
    let postKeys: [String]
    
    let numberOfSubscribers: Int
    let numberOfSubscriptions: Int
    
    init(snapshot: DataSnapshot)
    {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        
        userName = snapshotValue["username"] as! String
        userImageKey = snapshotValue["avatar"] as! String
        
        postKeys = snapshotValue["posts"] as! [String]
        
        numberOfSubscribers = snapshotValue["subscribers"] as! Int
        numberOfSubscriptions = (snapshotValue["publishers"] as! [String]).count
    }
    
    init(userName: String = "", userImageKey: String = "", postKeys: [String] = [""], numberOfSubscribers: Int = 0, numberOfSubscriptions: Int = 0)
    {
        self.userName = userName
        self.userImageKey = userImageKey
        
        self.postKeys = postKeys
        
        self.numberOfSubscribers = numberOfSubscribers
        self.numberOfSubscriptions = numberOfSubscriptions
    }
}
