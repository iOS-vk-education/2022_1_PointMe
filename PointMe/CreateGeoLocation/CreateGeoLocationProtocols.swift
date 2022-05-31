import Foundation

protocol CreateGeoLocationModuleInput {
	var moduleOutput: CreateGeoLocationModuleOutput? { get }
}

protocol CreateGeoLocationModuleOutput: AnyObject {
    func sendPlace(address: String, latitude: Double, longitude: Double)
}

protocol CreateGeoLocationViewInput: AnyObject {
    func showAdress(value: String)
}

protocol CreateGeoLocationViewOutput: AnyObject {
    func didTapPoint(latitude: Double, longitude: Double)
    
    func didTapButtonConfirme()
    
    var location: (latitude: Double, longitude: Double)? { get }
}

protocol CreateGeoLocationInteractorInput: AnyObject {
    func fetchGeodata(latitude: Double, longitude: Double)
    
    var adress: String? { get }
    
    var location: (latitude: Double, longitude: Double)? { get }
}

protocol CreateGeoLocationInteractorOutput: AnyObject {
    func isSuccessLoad(isSuccess: Bool)
}

protocol CreateGeoLocationRouterInput: AnyObject {
    func showCreatePostSreen()
}
