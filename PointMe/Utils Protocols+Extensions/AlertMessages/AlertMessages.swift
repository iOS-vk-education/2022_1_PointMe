import UIKit


protocol AlertMessages: AnyObject {}

extension AlertMessages {
    func showWarningAlert(forTitleText title: String, forBodyText text: String, viewController: UIViewController, action: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: text,
            preferredStyle: UIAlertController.Style.alert
        )
        let alertAction: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) { _ in
            action?()
        }
        alert.addAction(alertAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showDestructiveAlertTwoButtons(forTitleText title: String,
                                   forBodyText text: String,
                                   destructiveText: String,
                                   cancelText: String,
                                   viewController: UIViewController,
                                   destructiveAction: @escaping () -> Void,
                                   actionTwo: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: text,
            preferredStyle: UIAlertController.Style.alert
        )
        let alertActionOne: UIAlertAction = UIAlertAction(title: destructiveText, style: .destructive) { _ in
            destructiveAction()
        }
        let alertActionTwo: UIAlertAction = UIAlertAction(title: cancelText, style: .cancel) { _ in
            actionTwo?()
        }
        alert.addAction(alertActionTwo)
        alert.addAction(alertActionOne)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    func showInfoAlert(forTitleText title: String, forBodyText text: String, viewController: UIViewController, action: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: text,
            preferredStyle: UIAlertController.Style.alert
        )
        let alertAction: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { _ in
            action?()
        }
        alert.addAction(alertAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
