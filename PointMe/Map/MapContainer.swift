//
//  MapContainer.swift
//  PointMe
//
//  Created by Павел Топорков on 28.05.2022.
//  
//

import UIKit

final class MapContainer {
    let input: MapModuleInput
	let viewController: UIViewController
	private(set) weak var router: MapRouterInput!

	class func assemble(with context: MapContext) -> MapContainer {
        let router = MapRouter()
        let interactor = MapInteractor()
        let presenter = MapPresenter(router: router, interactor: interactor)
		let viewController = MapViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput

		interactor.output = presenter
        
        router.viewController = viewController

        return MapContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: MapModuleInput, router: MapRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct MapContext {
	weak var moduleOutput: MapModuleOutput?
}
