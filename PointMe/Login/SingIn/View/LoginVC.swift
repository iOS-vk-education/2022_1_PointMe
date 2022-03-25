
import UIKit

class LoginViewController: UIViewController {
    /// textField for login or email
    private let textFieldUsernameOrEmail: AuthTextField = {
        let textField = AuthTextField()
        
        textField.placeholder = "Email/имя пользователя"
        
        return textField
    }()
    
    
    /// textField for password
    private let textFieldPassword: AuthTextField = {
        let textField = AuthTextField()
        
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    
    /// button for Singin
    private let loginButton: AuthButton = {
        let button = AuthButton()
        
        button.configure(title: "Войти")
        
        return button
    }()
    
    
    private let registrationButton: TextButton = {
        let button = TextButton()
        
        button.configure(title: "Зарегестрироваться")
        
        return button
    }()
    
    
    private struct Constants {
        // for textFilds layout
        static let startOffsetByCenterTextField: CGFloat = -5
        static let deltaOffsetByCenterTextField: CGFloat = 70
        static let horizontalMarginTextField: CGFloat = 20
        static let heightTextFileld: CGFloat = 55
        
        // for authButton layout
        static let heightAuthButton: CGFloat = 56
        static let marginTopAuthButton: CGFloat = 60
        static let marginHorizontalAuthButton: CGFloat = 20
        
        // for textButton layout
        static let heightTextButton: CGFloat = 29
        static let marginTopTextButton: CGFloat = 15
        static let marginHorizontalTextButton: CGFloat = 120
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTextFieldUsernameOrEmail()
        self.setupTextFieldPassword()
        self.setupLoginButton()
        self.setupRegistrationButton()
    }
    
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    
    private func setupTextFieldUsernameOrEmail() {
        self.view.addSubview(textFieldUsernameOrEmail)
    }
    
    
    private func setupTextFieldPassword() {
        self.view.addSubview(textFieldPassword)
    }
    
    
    private func setupLoginButton() {
        self.view.addSubview(loginButton)
        self.loginButton.setAction {
            // MARK: FIX ME!
            print("call method for SingIn from viewModel")
        }
    }
    
    
    private func setupRegistrationButton() {
        self.view.addSubview(registrationButton)
        self.registrationButton.setAction {
            // MARK: FIX ME!
            print("go to SingUpViewController")
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupLayoutTextFields()
        self.setupLayoutLoginButton()
        self.setupLayoutRegistrationButton()
    }
    
    
    private func setupLayoutTextFields() {
        var offsetByCenter: CGFloat = Constants.startOffsetByCenterTextField
        
        _ = [self.textFieldPassword, self.textFieldUsernameOrEmail].map {
            $0.pin.height(Constants.heightTextFileld)
                .left(Constants.horizontalMarginTextField)
                .right(Constants.horizontalMarginTextField)
                .vCenter(offsetByCenter)
            
            offsetByCenter -= Constants.deltaOffsetByCenterTextField
        }
    }
    
    
    private func setupLayoutLoginButton() {
        self.loginButton.pin.below(of: self.textFieldPassword)
            .left(Constants.marginHorizontalAuthButton)
            .right(Constants.marginHorizontalAuthButton)
            .height(Constants.heightAuthButton)
            .marginTop(Constants.marginTopAuthButton)
    }
    
    
    private func setupLayoutRegistrationButton() {
        print("hello")
        self.registrationButton.pin
            .below(of: self.loginButton)
            .left().right()
            .height(Constants.heightTextButton)
            .marginTop(Constants.marginTopTextButton)
    }
    
}
