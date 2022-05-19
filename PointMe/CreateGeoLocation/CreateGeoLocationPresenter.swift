import Foundation

final class CreateGeoLocationPresenter {
	weak var view: CreateGeoLocationViewInput?
    weak var moduleOutput: CreateGeoLocationModuleOutput?

	private let router: CreateGeoLocationRouterInput
	private let interactor: CreateGeoLocationInteractorInput

    init(router: CreateGeoLocationRouterInput, interactor: CreateGeoLocationInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension CreateGeoLocationPresenter: CreateGeoLocationModuleInput {}

extension CreateGeoLocationPresenter: CreateGeoLocationViewOutput {
    func didTapPoint(latitude: Double, longitude: Double) {
        interactor.fetchGeodata(latitude: latitude, longitude: longitude)
    }
}

extension CreateGeoLocationPresenter: CreateGeoLocationInteractorOutput {
    func isSuccessLoad(isSuccess: Bool) {
        view?.showAdress(value: interactor.adress)
    }
}
