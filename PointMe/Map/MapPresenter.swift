//
//  MapPresenter.swift
//  PointMe
//
//  Created by Павел Топорков on 28.05.2022.
//  
//

import Foundation

final class MapPresenter: NSObject {
	weak var view: MapViewInput?
    weak var moduleOutput: MapModuleOutput?

	private let router: MapRouterInput
	private let interactor: MapInteractorInput

    init(router: MapRouterInput, interactor: MapInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension MapPresenter: MapModuleInput {}

extension MapPresenter: MapViewOutput {
    func didTapCluster(arrayIndex: [Int]) {
        let data = interactor.getPostsData(by: arrayIndex)
        router.showClusterPosts(data: data)
    }
    
    func showPost(by index: Int) {
        interactor.fetchAvatar4Post(by: index)
    }
    
    func loadMapData() {
        interactor.fetchMapData()
    }
}

extension MapPresenter: MapInteractorOutput {
    func notifyPostContext(context: PostContextWithoutAvatar?) {
        guard let context = context else {
            return
        }

        router.showPost(context: context)
    }
    
    func notifyMapData(isSuccess: Bool) {
        guard isSuccess else {
            print("notifyMapData false")
            return
        }
        
        for index in (0 ..< interactor.countMapObjs) {
            let data = interactor.getMapObj(by: index)
            view?.addDataToMap(index: index, geoData: (latitude: data.latitude, longitude: data.longitude))
        }
        
        view?.updateCluster()
    }
}
