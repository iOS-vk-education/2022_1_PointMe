import UIKit
import YandexMapsMobile
import CoreLocation

final class MapViewController: UIViewController {
	private let output: MapViewOutput
    
    private let mapView: YMKMapView = YMKMapView()
    
    private var placemark: YMKPlacemarkMapObject?
    
    private let locationManager = CLLocationManager()
    
    private var postsData: [PostData4Map] = []
    
    private var placemarkCollection: YMKClusterizedPlacemarkCollection?
    
    private var placemarkTapListener: YMKMapObjectTapListener?

    init(output: MapViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
		super.viewDidLoad()
        
        title = "Карта"
        view.backgroundColor = .white
        
        [mapView].forEach {
            view.addSubview($0)
        }
        
        setupLayout()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        placemarkCollection = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        placemarkTapListener = PlacemarkMapObjectTapListener(controller: self, output: output)
        
        output.loadMapData()
	}
    
    private func setupLayout() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setMap(location: CLLocationCoordinate2D) {
        let point = YMKPoint(latitude: location.latitude, longitude: location.longitude)
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: point, zoom: 11, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil
        )
    }
}

extension MapViewController: MapViewInput {
    func updateCluster() {
        placemarkCollection?.clusterPlacemarks(withClusterRadius: 60, minZoom: 15)
    }
    
    func addDataToMap(index: Int, geoData: (latitude: Double, longitude: Double)) {
        let dataObj = placemarkCollection?.addPlacemark(
            with: YMKPoint(latitude: geoData.latitude, longitude: geoData.longitude),
            image: UIImage(named: "pin")!,
            style: YMKIconStyle()
        )
        
        let userData: [String: Any] = ["id" : index]
        dataObj?.userData = userData
        if let placemarkTapListener = placemarkTapListener {
            dataObj?.addTapListener(with: placemarkTapListener)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let currentLocation = (latitude: locValue.latitude, longitude: locValue.longitude)
        setMap(location: CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
        print("\(currentLocation)")
//        createPinOnMap(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
    }
}

extension MapViewController: YMKClusterListener {
    func onClusterAdded(with cluster: YMKCluster) {
        cluster.appearance.setIconWith(clusterImage(cluster.size))
        cluster.addClusterTapListener(with: self)
    }
    
    func clusterImage(_ clusterSize: UInt) -> UIImage {
        let FONT_SIZE: CGFloat = 15
        let MARGIN_SIZE: CGFloat = 3
        let STROKE_SIZE: CGFloat = 3
        
        let scale = UIScreen.main.scale
        let text = (clusterSize as NSNumber).stringValue
        let font = UIFont.systemFont(ofSize: FONT_SIZE * scale)
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let internalRadius = textRadius + MARGIN_SIZE * scale
        let externalRadius = internalRadius + STROKE_SIZE * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)

        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!

        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));

        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));

        (text as NSString).draw(
            in: CGRect(
                origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
                size: size),
            withAttributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
}

extension MapViewController: YMKClusterTapListener {
    func onClusterTap(with cluster: YMKCluster) -> Bool {
        let indexs: [Int] = cluster.placemarks.map {
            guard let userData = $0.userData as? [String: Int] else {
                return 0
            }
            return userData["id"] ?? 0
        }
        
        output.didTapCluster(arrayIndex: indexs)
        return true
    }
}

