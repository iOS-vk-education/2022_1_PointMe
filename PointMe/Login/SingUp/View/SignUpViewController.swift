import UIKit
import PinLayout


final class SignUpViewController: UIViewController, AlertMessages {
    
    // MARK: - Private properties (UI)
    
    private lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Имя пользователя"
        label.textColor = .textFieldPlaceholderColor
        label.font = .textFieldPlaceholderFont
        
        return label
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
    
    
    private lazy var textFieldUsername: UITextField = {
        let textField = UITextField()
        
        textField.font = .textFieldInput
        textField.textColor = .textFieldInputColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.contentVerticalAlignment = .bottom
        
        return textField
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
    
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Присоединиться", for: .normal)
        button.titleLabel?.font = .buttonTitle
        button.backgroundColor = .buttonColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.Buttons.cornerRadius
        
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
    
    
    private lazy var privacyLabel: UILabel = {
        let lable: UILabel = UILabel()
        
        lable.text = "Нажимая “Присоединиться”, вы принимаете Условия использования и Политику конфиденциальности  PointMe"
        lable.numberOfLines = 2
        lable.font = .authPS
        lable.textAlignment = .center
        lable.textColor = .privacyLabelColor
        
        return lable
    }()
    
    
    private let model: SignUpModel = SignUpModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.backgroundColor = .authScreensBackgroundColor
        
        [textFieldUsername, textFieldEmail, textFieldPassword, usernameLabel, emailLabel, passwordLabel].forEach {
            containerTextFieldsView.addSubview($0)
        }
        
        underlines.forEach {
            containerTextFieldsView.addSubview($0)
        }
        
        [signUpButton, privacyLabel].forEach {
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
        
        passwordLabel.pin
            .above(of: textFieldPassword)
            .horizontally()
            .height(usernameLabel.font.pointSize)
        
        underlines[0].pin
            .below(of: textFieldPassword)
            .horizontally()
            .height(Constants.ContainerTextFields.widthUnderline)
        
        textFieldEmail.pin
            .height(Constants.ContainerTextFields.heightTextFileld)
            .horizontally(Constants.ContainerTextFields.horizontalMarginTextField)
            .bottom(Constants.ContainerTextFields.spacingBetweenTextFields + Constants.ContainerTextFields.widthUnderline)
        
        emailLabel.pin
            .above(of: textFieldEmail)
            .horizontally()
            .height(emailLabel.font.pointSize)
        
        underlines[1].pin
            .below(of: textFieldEmail)
            .horizontally()
            .height(Constants.ContainerTextFields.widthUnderline)
        
        textFieldUsername.pin
            .height(Constants.ContainerTextFields.heightTextFileld)
            .horizontally(Constants.ContainerTextFields.horizontalMarginTextField)
            .bottom(Constants.ContainerTextFields.spacingBetweenTextFields * 2 + Constants.ContainerTextFields.widthUnderline)
        
        usernameLabel.pin
            .above(of: textFieldUsername)
            .horizontally()
            .height(passwordLabel.font.pointSize)
        
        underlines[2].pin
            .below(of: textFieldUsername)
            .horizontally()
            .height(Constants.ContainerTextFields.widthUnderline)
        
        
        containerTextFieldsView.pin
            .bottom(view.bounds.height / 2)
            .wrapContent()
        
        signUpButton.pin
            .below(of: containerTextFieldsView)
            .horizontally(Constants.Buttons.marginHorizontalSignUpButton)
            .height(Constants.Buttons.heightSignUpButton)
            .marginTop(Constants.Buttons.marginTopSignUpButton)
        
        privacyLabel.pin
            .height(Constants.LabelPS.heightLabel)
            .bottom(view.safeAreaInsets.bottom)
            .horizontally(Constants.LabelPS.hotizontalMargin)
    }
    
    // MARK: - Actions
    
    @objc private func didTapSignUpButton(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            UIView.animate(withDuration: Constants.Buttons.durationAnimation) { [weak self] in
                self?.signUpButton.alpha = Constants.Buttons.tapOpacity
            }
        }
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: Constants.Buttons.durationAnimation) { [weak self] in
                self?.signUpButton.alpha = Constants.Buttons.identityOpacity
            } completion: { [weak self] _ in
                guard let self = self else {
                    return
                }
                
                let username = self.textFieldUsername.text
                let email = self.textFieldEmail.text
                let password = self.textFieldPassword.text
                
                self.model.signUpUser(email: email, password: password, username: username) { result in
                    switch result {
                    case .success:
                        self.showInfoAlert(
                            forTitleText: "Подтверждение",
                            forBodyText: "Вы успешно зарегестрированы!",
                            viewController: self,
                            action: {
                                self.presentTabBar()
                            }
                        )
                        break
                    case .failure(_):
                        self.showWarningAlert(
                            forTitleText: "\("Ошибка")",
                            forBodyText: "Введите корректные имя пользователя, email и пароль (должен быть не менее 6 символов)!",
                            viewController: self
                        )
                        break
                    }
                }
            }
        }
    }
    
    
    private func presentTabBar() {
        let tabBarController: TabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        present(tabBarController, animated: true)
    }
}


private extension SignUpViewController {
    // MARK: - Constans
    private struct Constants {
        struct Buttons {
            static let tapOpacity: CGFloat = 0.7
            static let identityOpacity: CGFloat = 1.0
            static let cornerRadius: CGFloat = 10
            static let durationAnimation: TimeInterval = 0.1
            static let minPressDuration: TimeInterval = 0
            
            static let heightSignUpButton: CGFloat = 56
            static let marginTopSignUpButton: CGFloat = 60
            static let marginHorizontalSignUpButton: CGFloat = 20
        }
        
        struct ContainerTextFields {
            static let horizontalMarginContainer: CGFloat = 20
            
            static let widthUnderline: CGFloat = 1.0
            
            static let countTextFields: Int = 3
            static let spacingBetweenTextFields: CGFloat = 70
            static let horizontalMarginTextField: CGFloat = 1
            static let heightTextFileld: CGFloat = 40
        }
        
        struct LabelPS {
            static let hotizontalMargin: CGFloat = 18
            static let bottomMargin: CGFloat = 18
            static let heightLabel: CGFloat = 50
        }
    }
}

