import UIKit

final class PasswordEditBuilder {
    func build() -> UIViewController {
        let viewController = PasswordEditViewController()
        let model = PasswordEditModel()
        
        viewController.model = model
        model.output = viewController
        
        return viewController
    }
}
