//
//  MapProtocols.swift
//  PointMe
//
//  Created by Павел Топорков on 28.05.2022.
//  
//

import Foundation

protocol MapModuleInput {
	var moduleOutput: MapModuleOutput? { get }
}

protocol MapModuleOutput: AnyObject {
}

protocol MapViewInput: AnyObject {
    func addDataToMap(index: Int, geoData: (latitude: Double, longitude: Double))
    
    func updateCluster()
}

protocol MapViewOutput: AnyObject {
    func loadMapData()
    
    func showPost(by index: Int)
    
    func didTapCluster(arrayIndex: [Int])
}

protocol MapInteractorInput: AnyObject {
    func fetchMapData()
    
    func fetchAvatar4Post(by index: Int)
    
    func getMapObj(by index: Int) -> (latitude: Double, longitude: Double)
    
    func getUid4Post(by index: Int) -> String
    
    var countMapObjs: Int { get }
    
    func getPostsData(by arrayIndex: [Int]) -> [PostData4Map]
}

protocol MapInteractorOutput: AnyObject {
    func notifyMapData(isSuccess: Bool)
    
    func notifyPostContext(context: PostContextWithoutAvatar?)
}

protocol MapRouterInput: AnyObject {
    func showPost(context: PostContextWithoutAvatar)
    
    func showClusterPosts(data: [PostData4Map])
}
