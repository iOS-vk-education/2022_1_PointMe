import UIKit


final class SignInViewController: UIViewController {
    
    /// MARK: - placeholder for  textField (email or username)
    private lazy var labelForEmailOrUsername: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Email/Имя пользователя"
        label.textColor = .textFieldPlaceholderColor
        label.font = .textFieldPlaceholderFont
        
        return label
    }()
    
    
    /// MARK: - placeholder for  textField (password)
    private lazy var labelForPassword: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Пароль"
        label.textColor = .textFieldPlaceholderColor
        label.font = .textFieldPlaceholderFont
        
        return label
    }()
    
    
    /// MARK: - array views for textField's underline
    private lazy var underlines: [UIView] = {
        var arrayUnderlines: [UIView] = []
        
        (0 ..< Constants.ContainerTextFields.countTextFields).forEach { _ in
            let underline = UIView()
            underline.backgroundColor = .black
            arrayUnderlines.append(underline)
        }
        
        return arrayUnderlines
    }()
    
    
    /// MARK: - textField for login or email
    private lazy var textFieldUsernameOrEmail: UITextField = {
        let textField = UITextField()
        
        textField.font = .textFieldInput
        textField.textColor = .textFieldInputColor
        textField.keyboardType = .emailAddress
        textField.borderStyle = UITextField.BorderStyle.none
        textField.contentVerticalAlignment = .bottom
        
        return textField
    }()
    
    
    /// MARK: - textField for password
    private lazy var textFieldPassword: UITextField = {
        let textField = UITextField()
        
        textField.font = .textFieldInput
        textField.textColor = .textFieldInputColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.contentVerticalAlignment = .bottom
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    
    /// MARK: - button for SignIn
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font =  .buttonTitle
        button.backgroundColor = .buttonColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.Buttons.cornerRadius
        
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(didLongPressSignInButton)
        )
        gesture.minimumPressDuration = Constants.Buttons.minPressDuration
        button.addGestureRecognizer(gesture)
        
        return button
    }()
    
    
    /// MARK: - button text for SignIn
    private lazy var signUpButtonLabel: UILabel = {
        let button: UILabel = UILabel()
        
        button.text = "Зарегестрироваться"
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
            action: #selector(didLongPressSignUpButton)
        )
        gesture.minimumPressDuration = Constants.Buttons.minPressDuration
        button.addGestureRecognizer(gesture)
        
        return button
    }()
    
    
    /// MARK: - container view for textFilds, placeholders and underlines
    private lazy var containerTextFieldsView: UIView = {
        let container: UIView = UIView()
        
        container.backgroundColor = .white
        
        return container
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        setupNavigationBar()
        setupContainerTextFields()
        setupButtons()
    }
    
    
    private func setupNavigationBar() {
        self.title = "PointMe"
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    
    private func setupContainerTextFields() {
        [textFieldUsernameOrEmail, textFieldPassword].forEach {
            containerTextFieldsView.addSubview($0)
            
        }
        
        [labelForEmailOrUsername, labelForPassword].forEach {
            containerTextFieldsView.addSubview($0)
        }
        
        underlines.forEach {
            containerTextFieldsView.addSubview($0)
        }
        
        view.addSubview(containerTextFieldsView)
    }
    
    
    private func setupButtons() {
        [signInButton, signUpButtonLabel].forEach {
            view.addSubview($0)
        }
    }
    
    
    // MARK: Setup Layout
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayoutContainerTextFields()
        setupLayoutButtons()
    }
    
    
    private func setupLayoutContainerTextFields() {
        var offsetByCenter: CGFloat = 0
        var indexUnderline: Int = 0
        
        containerTextFieldsView.pin
            .horizontally(Constants.ContainerTextFields.horizontalMarginContainer)
        
        [textFieldPassword, textFieldUsernameOrEmail].forEach {
            $0.pin.height(Constants.ContainerTextFields.heightTextFileld)
                .horizontally(Constants.ContainerTextFields.horizontalMarginTextField)
                .bottom(offsetByCenter + 1)
            
            underlines[indexUnderline].pin.below(of: $0)
                .horizontally()
                .height(Constants.ContainerTextFields.widthUnderline)
            
            indexUnderline += 1
            offsetByCenter += Constants.ContainerTextFields.spacingBetweenTextFields
        }
        
        labelForEmailOrUsername.pin.above(of: textFieldUsernameOrEmail)
            .horizontally()
            .height(labelForEmailOrUsername.font.pointSize)
        
        labelForPassword.pin.above(of: textFieldPassword)
            .horizontally()
            .height(labelForPassword.font.pointSize)
        
        containerTextFieldsView.pin
            .bottom(view.bounds.height / 2)
            .wrapContent()
    }
    
    
    private func setupLayoutButtons() {
        signInButton.pin.below(of: containerTextFieldsView)
            .horizontally(Constants.Buttons.marginHorizontalSignInButton)
            .height(Constants.Buttons.heightSignInButton)
            .marginTop(Constants.Buttons.marginTopSignInButton)

        signUpButtonLabel.pin.below(of: signInButton)
            .horizontally()
            .height(Constants.Buttons.heightSignUpButton)
            .marginTop(Constants.Buttons.marginTopSignUpButton)
    }
    
    
    // MARK: Setup targets for buttons
    
    
    @objc private func didLongPressSignInButton(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            UIView.animate(withDuration: Constants.Buttons.durationAnimation) { [weak self] in
                self?.signInButton.alpha = Constants.Buttons.tapOpacity
            }
        }
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: Constants.Buttons.durationAnimation) { [weak self] in
                self?.signInButton.alpha = Constants.Buttons.identityOpacity
            } completion: { [weak self] _ in
                let tabbar: TabBarController = TabBarController()
                tabbar.modalPresentationStyle = .fullScreen
                tabbar.modalTransitionStyle = .crossDissolve
                self?.present(tabbar, animated: true)
            }
        }
    }
    
    
    @objc private func didLongPressSignUpButton(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            UIView.animate(withDuration: Constants.Buttons.durationAnimation) { [weak self] in
                self?.signUpButtonLabel.alpha = Constants.Buttons.tapOpacity
            }
        }
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: Constants.Buttons.durationAnimation) { [weak self] in
                self?.signUpButtonLabel.alpha = Constants.Buttons.identityOpacity
            } completion: { [weak self] _ in
                let viewController: UIViewController = SignUpViewController()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}


private extension SignInViewController {
    /// MARK: - constans values
    private struct Constants {
        // for buttons
        struct Buttons {
            // for buttons activity
            static let tapOpacity: CGFloat = 0.7
            static let identityOpacity: CGFloat = 1.0
            static let cornerRadius: CGFloat = 10
            static let durationAnimation: TimeInterval = 0.1
            static let minPressDuration: TimeInterval = 0
            
            // for signIn layout
            static let heightSignInButton: CGFloat = 56
            static let marginTopSignInButton: CGFloat = 60
            static let marginHorizontalSignInButton: CGFloat = 20
            
            // for signIn layout
            static let heightSignUpButton: CGFloat = 29
            static let marginTopSignUpButton: CGFloat = 15
            static let marginHorizontalSignUpButton: CGFloat = 120
        }
        
        // for container 
        struct ContainerTextFields {
            // for container
            static let horizontalMarginContainer: CGFloat = 20
            
            // for underlines
            static let widthUnderline: CGFloat = 1.0
            
            // for textFields
            static let countTextFields: Int = 2
            static let spacingBetweenTextFields: CGFloat = 70
            static let horizontalMarginTextField: CGFloat = 1
            static let heightTextFileld: CGFloat = 40
        }
    }
}
