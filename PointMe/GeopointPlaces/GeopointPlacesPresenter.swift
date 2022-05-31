//
//  GeopointPlacesPresenter.swift
//  PointMe
//
//  Created by Павел Топорков on 28.05.2022.
//  
//

import Foundation

final class GeopointPlacesPresenter {
	weak var view: GeopointPlacesViewInput?
    weak var moduleOutput: GeopointPlacesModuleOutput?

	private let router: GeopointPlacesRouterInput
	private let interactor: GeopointPlacesInteractorInput

    init(router: GeopointPlacesRouterInput, interactor: GeopointPlacesInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension GeopointPlacesPresenter: GeopointPlacesModuleInput {}

extension GeopointPlacesPresenter: GeopointPlacesViewOutput {
    func didTapButtonShowPost(index: Int) {
        let context = interactor.getNeedContext(by: index)
        router.showPost(context: context)
    }
    
    var countPosts: Int {
        return interactor.countPosts
    }
    
    func getPost(by index: Int) -> PostData4Map {
        return interactor.getPost(by: index)
    }
}

extension GeopointPlacesPresenter: GeopointPlacesInteractorOutput {}
