import Foundation

final class PostPreviewCellModel {
    
    private var userPreviewModel: UserPreviewModel?
    private var imageData: Data? = nil

    var username: String {
        get {
            userPreviewModel?.username ?? ""
        }
    }
    
    var avatarData: Data? {
        get {
            userPreviewModel?.avatarData
        }
    }
    
    var imagePreview: Data? {
        get {
            imageData
        }
    }
    
}
