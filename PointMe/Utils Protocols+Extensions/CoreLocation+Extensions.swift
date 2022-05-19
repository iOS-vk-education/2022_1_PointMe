import CoreLocation
import YandexMapsMobile

extension CLLocationCoordinate2D {
    var pointYMK: YMKPoint {
        return YMKPoint(latitude: latitude, longitude: longitude)
    }
}

extension YMKPoint {
    var pointCL: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
