import UIKit

final class SomeOneAccountBuilder {
    
    func build(uid: String) -> UIViewController {
        let viewController = SomeOneAccountViewController()
        let presenter = SomeOneAccountPresenter()
        let model = SomeOneAccountNetwork()
        
        viewController.someOneAccountInfo.uid = uid
        viewController.output = presenter
        presenter.view = viewController
        presenter.model = model
        
        return viewController
    }
}
