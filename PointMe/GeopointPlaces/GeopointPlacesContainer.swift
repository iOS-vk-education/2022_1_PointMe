//
//  GeopointPlacesContainer.swift
//  PointMe
//
//  Created by Павел Топорков on 28.05.2022.
//  
//

import UIKit

final class GeopointPlacesContainer {
    let input: GeopointPlacesModuleInput
	let viewController: UIViewController
	private(set) weak var router: GeopointPlacesRouterInput!

	class func assemble(with context: GeopointPlacesContext) -> GeopointPlacesContainer {
        let router = GeopointPlacesRouter()
        let interactor = GeopointPlacesInteractor()
        let presenter = GeopointPlacesPresenter(router: router, interactor: interactor)
		let viewController = GeopointPlacesViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter
        interactor.savePosts(data: context.posts)
        
        router.viewController = viewController

        return GeopointPlacesContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: GeopointPlacesModuleInput, router: GeopointPlacesRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct GeopointPlacesContext {
	weak var moduleOutput: GeopointPlacesModuleOutput?
    var posts: [PostData4Map]
}
