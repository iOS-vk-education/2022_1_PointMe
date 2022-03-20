import UIKit
import YandexMapsMobile


class ViewController: UIViewController {
    
    private let mapView: YMKMapView = YMKMapView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMap()
    }
    
    
    private func initMap() {
        mapView.frame = view.bounds
        view.addSubview(mapView)
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: 53.5, longitude: 33.0),
                zoom: 15,
                azimuth: 0,
                tilt: 0
            ),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil
        )
    }
}
