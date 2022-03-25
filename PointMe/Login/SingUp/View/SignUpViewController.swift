import UIKit
import PinLayout


final class SignUpViewController: UIViewController {
    /// textField for login
    private let textFieldUsername: AuthTextField = {
        let textField = AuthTextField()
        
        textField.placeholder = "Имя пользователя"
        
        return textField
    }()
    
    
    /// textField for email
    private let textFieldEmail: AuthTextField = {
        let textField = AuthTextField()
        
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        
        return textField
    }()
    
    
    /// textField for password
    private let textFieldPassword: AuthTextField = {
        let textField = AuthTextField()
        
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    
    /// button for SingUp
    private let registerButton: AuthButton = {
        let button = AuthButton()
        
        button.configure(title: "Присоединиться")
        
        return button
    }()
    
    
    /// label containing registration rules P.S.
    private let labelPS: UILabel = {
        let lable: UILabel = UILabel()
        
        lable.text = "Нажимая “Присоединиться”, вы принимаете Условия использования и Политику конфиденциальности  PointMe"
        lable.numberOfLines = 2
        lable.font = .authPS
        lable.textAlignment = .center
        lable.textColor = .authPS
        
        return lable
    }()
    
    
    private struct Constants {
        // for textFilds layout
        static let startOffsetByCenterTextField: CGFloat = -5
        static let deltaOffsetByCenterTextField: CGFloat = -5
        static let horizontalMarginTextField: CGFloat = 20
        static let heightTextFileld: CGFloat = 55
        
        // for authButton layout
        static let heightAuthButton: CGFloat = 56
        static let marginTopAuthButton: CGFloat = 60
        static let marginHorizontalAuthButton: CGFloat = 20
        
        // for labelPS
        static let heightlabel: CGFloat = 50
        static let marginBottomLabel: CGFloat = 20
        static let marginHorizontalLabel: CGFloat = 18
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTextFieldUsername()
        self.setupTextFieldEmail()
        self.setupTextFieldPassword()
        self.setupRegisterButton()
        self.setupLabelPS()
    }
    
    
    private func setupView() {
        view.backgroundColor = .defaultBackgroundColor
    }
    
    
    private func setupTextFieldUsername() {
        self.view.addSubview(textFieldUsername)
    }
    
    
    private func setupTextFieldEmail() {
        self.view.addSubview(textFieldEmail)
    }
    
    
    private func setupTextFieldPassword() {
        self.view.addSubview(textFieldPassword)
    }
    
    
    private func setupRegisterButton() {
        self.view.addSubview(registerButton)
        self.registerButton.setAction {
            // MARK: FIX ME!
            print("call method for SingUp from viewModel")
        }
    }
    
    
    private func setupLabelPS() {
        self.view.addSubview(labelPS)
    }
    

    override func viewDidLayoutSubviews() {
        self.setupLayoutTextFields()
        self.setupLayoutRegisterButton()
        self.setupLayoutLabelPS()
    }
    
    
    private func setupLayoutTextFields() {
        var offsetByCenter: CGFloat = Constants.startOffsetByCenterTextField
        
        _ = [self.textFieldPassword, self.textFieldEmail, self.textFieldUsername].map {
            $0.pin.height(Constants.heightTextFileld)
                .left(Constants.horizontalMarginTextField)
                .right(Constants.horizontalMarginTextField)
                .vCenter(offsetByCenter)
            
            offsetByCenter -= Constants.deltaOffsetByCenterTextField
        }
    }
    
    
    private func setupLayoutRegisterButton() {
        self.registerButton.pin.below(of: self.textFieldPassword)
            .left(Constants.marginHorizontalAuthButton)
            .right(Constants.marginHorizontalAuthButton)
            .height(Constants.heightAuthButton)
            .marginTop(Constants.marginTopAuthButton)
    }
    
    
    private func setupLayoutLabelPS() {
        self.labelPS.pin
            .height(Constants.heightlabel)
            .left(Constants.marginHorizontalLabel)
            .right(Constants.marginHorizontalLabel)
            .bottom(Constants.marginBottomLabel)
    }

    
    /// touch event to deselect textFields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = [self.textFieldUsername, self.textFieldEmail, self.textFieldPassword].map {
            $0.resignFirstResponder()
        }
    }
}
