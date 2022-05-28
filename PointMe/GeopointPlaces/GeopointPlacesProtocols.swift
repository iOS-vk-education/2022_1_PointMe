//
//  GeopointPlacesProtocols.swift
//  PointMe
//
//  Created by Павел Топорков on 28.05.2022.
//  
//

import Foundation

protocol GeopointPlacesModuleInput {
	var moduleOutput: GeopointPlacesModuleOutput? { get }
}

protocol GeopointPlacesModuleOutput: AnyObject {
}

protocol GeopointPlacesViewInput: AnyObject {
    func reloadData()
}

protocol GeopointPlacesViewOutput: AnyObject {
    var countPosts: Int { get }
    
    func getPost(by index: Int) -> PostData4Map
    
    func didTapButtonShowPost(index: Int)
}

protocol GeopointPlacesInteractorInput: AnyObject {
    var countPosts: Int { get }
    
    func getPost(by index: Int) -> PostData4Map
    
    func savePosts(data: [PostData4Map])
    
    func getNeedContext(by index: Int) -> PostContextWithoutAvatar
}

protocol GeopointPlacesInteractorOutput: AnyObject {
}

protocol GeopointPlacesRouterInput: AnyObject {
    func showPost(context: PostContextWithoutAvatar)
}
