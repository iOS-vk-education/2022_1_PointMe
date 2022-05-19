import UIKit

final class CreateGeoLocationRouter {
    var viewController: UIViewController?
}

extension CreateGeoLocationRouter: CreateGeoLocationRouterInput {
    func showCreatePostSreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
