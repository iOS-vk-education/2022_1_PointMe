import Foundation

final class CreateGeoLocationPresenter {
    weak var view: CreateGeoLocationViewInput?
    weak var moduleOutput: CreateGeoLocationModuleOutput?
    
    private let router: CreateGeoLocationRouterInput
    private let interactor: CreateGeoLocationInteractorInput
    private var pointLocation: (latitude: Double, longitude: Double)?
    
    init(router: CreateGeoLocationRouterInput, interactor: CreateGeoLocationInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
    
    func setLocation(location: (latitude: Double, longitude: Double)?) {
        pointLocation = location
    }
}

extension CreateGeoLocationPresenter: CreateGeoLocationModuleInput {}

extension CreateGeoLocationPresenter: CreateGeoLocationViewOutput {
    var location: (latitude: Double, longitude: Double)? {
        return pointLocation
    }
    
    func didTapButtonConfirme() {
        guard let location = interactor.location, let address = interactor.adress else { return }
        moduleOutput?.sendPlace(address: address, latitude: location.latitude, longitude: location.longitude)
        router.showCreatePostSreen()
    }
    
    func didTapPoint(latitude: Double, longitude: Double) {
        interactor.fetchGeodata(latitude: latitude, longitude: longitude)
    }
}

extension CreateGeoLocationPresenter: CreateGeoLocationInteractorOutput {
    func isSuccessLoad(isSuccess: Bool) {
        guard isSuccess, let address = interactor.adress else {
            view?.showAdress(value: "Неизвестный адрес")
            return
        }
        
        view?.showAdress(value: address)
    }
}
