import Foundation

protocol FavoritesPostsListener {
    func addPost(post: PostPreviewModel)
    
    func removePost(by id: String)
    
    func notifySuccessLoading()
}

final class FavoritesPostsManager: FavoritesPostsListener {
    weak var model: FavoritesModel?
    
    func addPost(post: PostPreviewModel) {
        model?.addFavoritePost(post: post)
    }
    
    func removePost(by id: String) {
        model?.removeFavoritePost(id: id)
    }
    
    func notifySuccessLoading() {
        model?.notifyView()
    }
}
