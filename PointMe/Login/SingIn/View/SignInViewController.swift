import UIKit
import Firebase


final class SignInViewController: UIViewController, AlertMessages {
    
    // MARK: - Private properties (UI)
    
    private lazy var loadingAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Ожидание",
            message: "Пожалуйста подождите...",
            preferredStyle: UIAlertController.Style.alert
        )
        
        let loadingIndicator = UIActivityIndicatorView(
            frame: CGRect(
                x: 10,
                y: 5,
                width: 50,
                height: 50
            )
        )
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        
        return alert
    }()
    
    
    private lazy var emailLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Email"
        label.textColor = .textFieldPlaceholderColor
        label.font = .textFieldPlaceholderFont
        
        return label
    }()
    
    
    private lazy var passwordLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Пароль"
        label.textColor = .textFieldPlaceholderColor
        label.font = .textFieldPlaceholderFont
        
        return label
    }()
    
    
    private lazy var underlines: [UIView] = {
        var arrayUnderlines: [UIView] = []
        
        (0 ..< Constants.ContainerTextFields.countTextFields).forEach { _ in
            let underline = UIView()
            underline.backgroundColor = .black
            arrayUnderlines.append(underline)
        }
        
        return arrayUnderlines
    }()
    
    
    private lazy var textFieldEmail: UITextField = {
        let textField = UITextField()
        
        textField.font = .textFieldInput
        textField.textColor = .textFieldInputColor
        textField.keyboardType = .emailAddress
        textField.borderStyle = UITextField.BorderStyle.none
        textField.contentVerticalAlignment = .bottom
        
        return textField
    }()
    
    
    private lazy var textFieldPassword: UITextField = {
        let textField = UITextField()
        
        textField.font = .textFieldInput
        textField.textColor = .textFieldInputColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.contentVerticalAlignment = .bottom
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .buttonTitle
        button.backgroundColor = .buttonColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.Buttons.cornerRadius
        
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(didTapSignInButton)
        )
        gesture.minimumPressDuration = Constants.Buttons.minPressDuration
        button.addGestureRecognizer(gesture)
        
        return button
    }()
    
    
    private lazy var signUpButtonLabel: UILabel = {
        let button: UILabel = UILabel()
        
        button.text = "Зарегистрироваться"
        button.font = .textButtonTitle
        button.textColor = .textButtonColor
        button.textAlignment = .center
        button.isUserInteractionEnabled = true
        button.attributedText = NSAttributedString(
            string: button.text ?? "",
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(didTapSignUpButton)
        )
        gesture.minimumPressDuration = Constants.Buttons.minPressDuration
        button.addGestureRecognizer(gesture)
        
        return button
    }()
    
    
    private lazy var containerTextFieldsView: UIView = {
        let container: UIView = UIView()
        
        container.backgroundColor = .authScreensBackgroundColor
        
        return container
    }()
    
    
    private let model: SignInModel = SignInModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .authScreensBackgroundColor
        setupNavigationBar()
        
        [textFieldEmail, textFieldPassword, emailLabel, passwordLabel].forEach {
            containerTextFieldsView.addSubview($0)
        }
        
        underlines.forEach {
            containerTextFieldsView.addSubview($0)
        }
        
        [signInButton, signUpButtonLabel].forEach {
            view.addSubview($0)
        }
        
        view.addSubview(containerTextFieldsView)
    }
    
    // MARK: - Setups
    
    private func setupNavigationBar() {
        self.title = "PointMe"
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerTextFieldsView.pin
            .horizontally(Constants.ContainerTextFields.horizontalMarginContainer)
        
        textFieldPassword.pin
            .height(Constants.ContainerTextFields.heightTextFileld)
            .horizontally(Constants.ContainerTextFields.horizontalMarginTextField)
            .bottom(Constants.ContainerTextFields.widthUnderline)
        
        underlines[0].pin
            .below(of: textFieldPassword)
            .horizontally()
            .height(Constants.ContainerTextFields.widthUnderline)
        
        passwordLabel.pin
            .above(of: textFieldPassword)
            .horizontally()
            .height(passwordLabel.font.pointSize)
        
        textFieldEmail.pin
            .height(Constants.ContainerTextFields.heightTextFileld)
            .horizontally(Constants.ContainerTextFields.horizontalMarginTextField)
            .bottom(Constants.ContainerTextFields.spacingBetweenTextFields + Constants.ContainerTextFields.widthUnderline)
        
        underlines[1].pin
            .below(of: textFieldEmail)
            .horizontally()
            .height(Constants.ContainerTextFields.widthUnderline)
        
        emailLabel.pin
            .above(of: textFieldEmail)
            .horizontally()
            .height(emailLabel.font.pointSize)
        
        containerTextFieldsView.pin
            .bottom(view.bounds.height / 2)
            .wrapContent()
        
        signInButton.pin
            .below(of: containerTextFieldsView)
            .horizontally(Constants.Buttons.marginHorizontalSignInButton)
            .height(Constants.Buttons.heightSignInButton)
            .marginTop(Constants.Buttons.marginTopSignInButton)

        signUpButtonLabel.pin
            .below(of: signInButton)
            .horizontally()
            .height(Constants.Buttons.heightSignUpButton)
            .marginTop(Constants.Buttons.marginTopSignUpButton)
    }
    
    // MARK: - Actions
    
    @objc private func didTapSignInButton(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            UIView.animate(withDuration: Constants.Buttons.durationAnimation) { [weak self] in
                self?.signInButton.alpha = Constants.Buttons.tapOpacity
            }
        }
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: Constants.Buttons.durationAnimation) { [weak self] in
                self?.signInButton.alpha = Constants.Buttons.identityOpacity
            } completion: { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                self.present(self.loadingAlert, animated: true, completion: nil)
                
                let email = self.textFieldEmail.text
                let password = self.textFieldPassword.text

                self.model.signInUser(email: email, password: password, completion: { result in
                    switch result {
                    case .success:
                        self.loadingAlert.dismiss(animated: true, completion: nil)
                        self.showInfoAlert(
                            forTitleText: "Подтверждение",
                            forBodyText: "Вы успешно вошли!",
                            viewController: self,
                            action: {
                                self.presentTabBar()
                            }
                        )
                        break
                    case .failure(_):
                        self.loadingAlert.dismiss(animated: true, completion: {
                            self.showInfoAlert(
                                forTitleText: "Ошибка",
                                forBodyText: "Введите корректные email и пароль (должен быть не менее 6 символов)!",
                                viewController: self
                            )
                        })
                        break
                    }
                })
            }
        }
    }
    
    
    private func presentTabBar() {
        let tabBarController: TabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        present(tabBarController, animated: true)
    }
    
    
    @objc private func didTapSignUpButton(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            UIView.animate(withDuration: Constants.Buttons.durationAnimation) { [weak self] in
                self?.signUpButtonLabel.alpha = Constants.Buttons.tapOpacity
            }
        }
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: Constants.Buttons.durationAnimation) { [weak self] in
                self?.signUpButtonLabel.alpha = Constants.Buttons.identityOpacity
            } completion: { [weak self] _ in
                let signUpViewController: UIViewController = SignUpViewController()
                self?.navigationController?.pushViewController(signUpViewController, animated: true)
            }
        }
    }
}


private extension SignInViewController {
    // MARK: - Constans
    private struct Constants {
        struct Buttons {
            static let tapOpacity: CGFloat = 0.7
            static let identityOpacity: CGFloat = 1.0
            static let cornerRadius: CGFloat = 10
            static let durationAnimation: TimeInterval = 0.1
            static let minPressDuration: TimeInterval = 0
            
            static let heightSignInButton: CGFloat = 56
            static let marginTopSignInButton: CGFloat = 60
            static let marginHorizontalSignInButton: CGFloat = 20
            
            static let heightSignUpButton: CGFloat = 29
            static let marginTopSignUpButton: CGFloat = 15
            static let marginHorizontalSignUpButton: CGFloat = 120
        }
        
        struct ContainerTextFields {
            static let horizontalMarginContainer: CGFloat = 20
            
            static let widthUnderline: CGFloat = 1.0
            
            static let countTextFields: Int = 2
            static let spacingBetweenTextFields: CGFloat = 70
            static let horizontalMarginTextField: CGFloat = 1
            static let heightTextFileld: CGFloat = 40
        }
    }
}
