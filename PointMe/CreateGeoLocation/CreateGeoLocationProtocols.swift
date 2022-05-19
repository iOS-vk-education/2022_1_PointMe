import Foundation

protocol CreateGeoLocationModuleInput {
	var moduleOutput: CreateGeoLocationModuleOutput? { get }
}

protocol CreateGeoLocationModuleOutput: AnyObject {}

protocol CreateGeoLocationViewInput: AnyObject {
    func showAdress(value: String)
}

protocol CreateGeoLocationViewOutput: AnyObject {
    func didTapPoint(latitude: Double, longitude: Double)
}

protocol CreateGeoLocationInteractorInput: AnyObject {
    func fetchGeodata(latitude: Double, longitude: Double)
    
    var adress: String { get }
}

protocol CreateGeoLocationInteractorOutput: AnyObject {
    func isSuccessLoad(isSuccess: Bool)
}

protocol CreateGeoLocationRouterInput: AnyObject {}
