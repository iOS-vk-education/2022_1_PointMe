import UIKit

final class CreateGeoLocationContainer {
    let input: CreateGeoLocationModuleInput
	let viewController: UIViewController
	private(set) weak var router: CreateGeoLocationRouterInput!

	class func assemble(with context: CreateGeoLocationContext) -> CreateGeoLocationContainer {
        let router = CreateGeoLocationRouter()
        let interactor = CreateGeoLocationInteractor()
        let presenter = CreateGeoLocationPresenter(router: router, interactor: interactor)
		let viewController = CreateGeoLocationViewController(output: presenter)

		presenter.view = viewController
		presenter.moduleOutput = context.moduleOutput
        presenter.setLocation(location: context.location)

		interactor.output = presenter
        
        router.viewController  = viewController

        return CreateGeoLocationContainer(view: viewController, input: presenter, router: router)
	}

    private init(view: UIViewController, input: CreateGeoLocationModuleInput, router: CreateGeoLocationRouterInput) {
		self.viewController = view
        self.input = input
		self.router = router
	}
}

struct CreateGeoLocationContext {
	weak var moduleOutput: CreateGeoLocationModuleOutput?
    let location: (latitude: Double, longitude: Double)?
}
