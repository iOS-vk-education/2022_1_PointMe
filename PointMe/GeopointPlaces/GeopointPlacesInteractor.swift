//
//  GeopointPlacesInteractor.swift
//  PointMe
//
//  Created by Павел Топорков on 28.05.2022.
//  
//

import Foundation

final class GeopointPlacesInteractor {
	weak var output: GeopointPlacesInteractorOutput?
    private var posts: [PostData4Map] = []
}

extension GeopointPlacesInteractor: GeopointPlacesInteractorInput {
    func getNeedContext(by index: Int) -> PostContextWithoutAvatar {
        return PostContextWithoutAvatar(
            idPost: self.posts[index].idPost,
            keysImages: self.posts[index].keysImages,
            username: self.posts[index].username,
            dateDay: self.posts[index].dateDay,
            dateMonth: self.posts[index].dateMonth,
            dateYear: self.posts[index].dateYear,
            title: self.posts[index].title,
            comment: self.posts[index].comment,
            mark: self.posts[index].mark,
            uid: self.posts[index].uid
        )
    }
    
    var countPosts: Int {
        return posts.count
    }
    
    func getPost(by index: Int) -> PostData4Map {
        posts[index]
    }
    
    func savePosts(data: [PostData4Map]) {
        posts = data
    }
}
