import Foundation
import CoreLocation

final class MapPresenter: NSObject {
	weak var view: MapViewInput?
    weak var moduleOutput: MapModuleOutput?

	private let router: MapRouterInput
	private let interactor: MapInteractorInput
    
    private let locationManager = CLLocationManager()

    init(router: MapRouterInput, interactor: MapInteractorInput) {
        self.router = router
        self.interactor = interactor
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
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
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        interactor.fetchMapData()
    }
}

extension MapPresenter: MapInteractorOutput {
    func notifyPostContext(context: PostContextWithoutAvatar?) {
        guard let context = context else {
            return
        }
        
        print("\(#function) = \(context)")

        router.showPost(context: context)
    }
    
    func notifyMapData(isSuccess: Bool) {
        guard isSuccess else {
            return
        }
        
        for index in (0 ..< interactor.countMapObjs) {
            let data = interactor.getMapObj(by: index)
            view?.addDataToMap(index: index, geoData: (latitude: data.latitude, longitude: data.longitude))
        }
        
        view?.updateCluster()
    }
}

extension MapPresenter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let currentLocation = (latitude: locValue.latitude, longitude: locValue.longitude)
        view?.setupMapCoords(coords: currentLocation)
    }
}
