import UIKit

final class ProfileEditBuilder {
    func build() -> UIViewController {
        let viewController = ProfileEditViewController()
        let model = ProfileEditModel()
        
        viewController.model = model
        model.output = viewController
        
        return viewController
    }
}
