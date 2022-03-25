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
        var offsetByCenter: CGFloat = -5
        
        _ = [self.textFieldPassword, self.textFieldEmail, self.textFieldUsername].map {
            $0.pin.height(55).left(20).right(20).vCenter(offsetByCenter)
            offsetByCenter -= 80
        }
    }
    
    
    private func setupLayoutRegisterButton() {
        self.registerButton.pin.below(of: textFieldPassword).left(20).right(20).height(56).marginTop(60)
    }
    
    
    private func setupLayoutLabelPS() {
        self.labelPS.pin.height(50).right(18).left(18).bottom(20)
    }

    
    /// touch event to deselect textFields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _ = [self.textFieldUsername, self.textFieldEmail, self.textFieldPassword].map {
            $0.resignFirstResponder()
        }
    }
}
