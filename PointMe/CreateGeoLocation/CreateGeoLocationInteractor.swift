import Foundation

final class CreateGeoLocationInteractor {
    weak var output: CreateGeoLocationInteractorOutput?
    private var adressValue: String?
    private var locationValue: (latitude: Double, longitude: Double)?
}

extension CreateGeoLocationInteractor: CreateGeoLocationInteractorInput {
    func fetchGeodata(latitude: Double, longitude: Double) {
        locationValue = (latitude: latitude, longitude: longitude)
        GeocoderManager.shared.loadDataPlaceBy(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let data):
                self?.adressValue = data
                self?.output?.isSuccessLoad(isSuccess: true)
                print("\(data)")
            case .failure(_):
                self?.output?.isSuccessLoad(isSuccess: false)
                print("error fetch addr")
            }
        }
    }
    
    var adress: String? {
        return adressValue
    }
    
    var location: (latitude: Double, longitude: Double)? {
        return locationValue
    }
}
