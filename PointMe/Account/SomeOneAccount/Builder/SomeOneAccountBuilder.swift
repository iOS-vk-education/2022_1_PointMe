import UIKit

final class SomeOneAccountBuilder {
    
    func build() -> UIViewController {
        let viewController = SomeOneAccountViewController()
        let presenter = SomeOneAccountPresenter()
        let model = SomeOneAccountNetwork()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.model = model
        
        return viewController
    }
}
