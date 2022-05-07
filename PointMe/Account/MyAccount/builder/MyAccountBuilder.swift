import UIKit

final class MyAccountBuilder {
    
    func build() -> UIViewController {
        let viewController = MyAccountViewController()
        let presenter = MyAccountPresenter()
        let model = MyAccountNetwork()
        
        viewController.output = presenter
        presenter.view = viewController
        presenter.model = model
        
        return viewController
    }
}
