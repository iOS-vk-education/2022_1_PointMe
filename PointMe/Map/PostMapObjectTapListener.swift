import Foundation
import YandexMapsMobile

class PlacemarkMapObjectTapListener: NSObject, YMKMapObjectTapListener {
    private weak var controller: UIViewController?
    private weak var output: MapViewOutput?
    
    init(controller: UIViewController, output: MapViewOutput) {
        self.controller = controller
        self.output = output
    }
    
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        if let mapObj = mapObject as? YMKPlacemarkMapObject {
            if let userData = mapObj.userData as? [String : Int] {
                output?.showPost(by: userData["id"] ?? 0)
            }
        }
        
        return true
    }
}
