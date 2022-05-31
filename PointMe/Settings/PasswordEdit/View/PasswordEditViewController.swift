import UIKit
import Firebase


final class PasswordEditViewController: UIViewController, AlertMessages {
    
    private let propertiesContainer: UIView = UIView()
    
    private var propertyContainer: [UIView] = []
    private var property: [(title: UILabel, textField: UITextField, separator: UIView)] = []
    
    private let acceptButton: UIButton = UIButton(type: .system)
    
    private let titles: [String] = ["Старый пароль", "Новый пароль", "Подтвердите новый пароль"]
    
    private var password: String = ""
    
    var model: PasswordEditViewControllerOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewProperties()
        setupView()
        getInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    private func setupViewProperties() {
        title = "Пароль"
        
        view.backgroundColor = .defaultBackgroundColor
        
        for i in 0..<Constants.PropertiesContainer.propertyQuantity {
            let container = UIView()
            let label = UILabel()
            let textField = UITextField()
            let separator = UIView()
            
            label.textColor = .defaultBlackColor
            label.font = .profileEditTitle
            label.text = titles[i]
            
            textField.font = .textFieldInput
            textField.textColor = .defaultBlackColor
            textField.textColor = .textFieldInputColor
            textField.keyboardType = .emailAddress
            textField.borderStyle = UITextField.BorderStyle.none
            textField.contentVerticalAlignment = .bottom
            textField.backgroundColor = .defaultWhiteColor
            textField.isSecureTextEntry = true
            
            container.backgroundColor = .none
            
            separator.backgroundColor = .defaultBackgroundColor
            
            propertyContainer.append(container)
            propertiesContainer.layer.cornerRadius = Constants.PropertiesContainer.cornerRadius
            property.append((label, textField, separator))
        }
        
        acceptButton.backgroundColor = .defaultBlackColor
        acceptButton.layer.cornerRadius = Constants.AcceptButton.cornerRadius
        acceptButton.setTitle("Сменить пароль", for: .normal)
        acceptButton.setTitleColor(.defaultWhiteColor, for: .normal)
        acceptButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        
        propertiesContainer.backgroundColor = .defaultWhiteColor
    }
    
    private func setupView() {
        
        for i in 0..<Constants.PropertiesContainer.propertyQuantity {
            propertyContainer[i].addSubview(property[i].title)
            propertyContainer[i].addSubview(property[i].textField)
            propertyContainer[i].addSubview(property[i].separator)
        }
        
        propertyContainer.forEach {
            propertiesContainer.addSubview($0)
        }
        
        [propertiesContainer, acceptButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        propertiesContainer.translatesAutoresizingMaskIntoConstraints = false
        propertyContainer[0].translatesAutoresizingMaskIntoConstraints = false
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            propertiesContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.PropertiesContainer.topIndent),
            propertiesContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.PropertiesContainer.leftRightIndent),
            propertiesContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.PropertiesContainer.leftRightIndent),
            propertiesContainer.heightAnchor.constraint(equalToConstant: (Constants.Property.height + Constants.Property.separatorHeight) * CGFloat(Constants.PropertiesContainer.propertyQuantity) + CGFloat(Constants.PropertiesContainer.propertyQuantity + 3) * Constants.Property.upDownIndent),
            
            propertyContainer[0].topAnchor.constraint(equalTo: propertiesContainer.topAnchor, constant: Constants.Property.upDownIndent * 2),
            propertyContainer[0].leftAnchor.constraint(equalTo: propertiesContainer.leftAnchor, constant: Constants.Property.leftRightIndent),
            propertyContainer[0].rightAnchor.constraint(equalTo: propertiesContainer.rightAnchor, constant: -Constants.Property.leftRightIndent),
            propertyContainer[0].heightAnchor.constraint(equalToConstant: Constants.Property.height + Constants.Property.separatorHeight)
        ])
        
        for i in 1..<Constants.PropertiesContainer.propertyQuantity {
            propertyContainer[i].translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                propertyContainer[i].topAnchor.constraint(equalTo: propertyContainer[i-1].bottomAnchor, constant: Constants.Property.upDownIndent),
                propertyContainer[i].leftAnchor.constraint(equalTo: propertyContainer[i-1].leftAnchor),
                propertyContainer[i].rightAnchor.constraint(equalTo: propertyContainer[i-1].rightAnchor),
                propertyContainer[i].heightAnchor.constraint(equalToConstant: Constants.Property.height + Constants.Property.separatorHeight)
            ])
        }
        
        for i in 0..<Constants.PropertiesContainer.propertyQuantity {
            property[i].title.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                property[i].title.topAnchor.constraint(equalTo: propertyContainer[i].topAnchor),
                property[i].title.leftAnchor.constraint(equalTo: propertyContainer[i].leftAnchor),
                property[i].title.rightAnchor.constraint(equalTo: propertyContainer[i].rightAnchor),
                property[i].title.heightAnchor.constraint(equalToConstant: Constants.Property.Title.fontSize)
            ])
            
            property[i].textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                property[i].textField.topAnchor.constraint(equalTo: property[i].title.bottomAnchor),
                property[i].textField.leftAnchor.constraint(equalTo: propertyContainer[i].leftAnchor),
                property[i].textField.rightAnchor.constraint(equalTo: propertyContainer[i].rightAnchor),
                property[i].textField.bottomAnchor.constraint(equalTo: propertyContainer[i].bottomAnchor, constant: -Constants.Property.separatorHeight)
            ])
            
            property[i].separator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                property[i].separator.topAnchor.constraint(equalTo: property[i].textField.bottomAnchor),
                property[i].separator.leftAnchor.constraint(equalTo: propertyContainer[i].leftAnchor),
                property[i].separator.rightAnchor.constraint(equalTo: propertyContainer[i].rightAnchor),
                property[i].separator.bottomAnchor.constraint(equalTo: propertyContainer[i].bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            acceptButton.topAnchor.constraint(equalTo: propertiesContainer.bottomAnchor, constant: Constants.AcceptButton.topIndent),
            acceptButton.leftAnchor.constraint(equalTo: propertiesContainer.leftAnchor),
            acceptButton.rightAnchor.constraint(equalTo: propertiesContainer.rightAnchor),
            acceptButton.heightAnchor.constraint(equalToConstant: Constants.AcceptButton.height)
        ])
    }
    
    @objc
    private func changePassword() {
        if (property[1].textField.text == property[2].textField.text && property[0].textField.text == password) {
            model?.changeInfo(password: property[1].textField.text ?? "")
        } else {
            makeAlert(forTitleText: "Внимание!", forBodyText: "Проверьте правильность ввода и попробуйте еще раз.")
        }
    }
    
    private func getInfo() {
        model?.getInfo()
    }
}

// MARK: - PasswordEditViewControllerInput

extension PasswordEditViewController: PasswordEditViewControllerInput {
    func makeAlert(forTitleText: String, forBodyText: String) {
        showWarningAlert(forTitleText: forTitleText, forBodyText: forBodyText, viewController: self)
    }
    
    func fetchInfo(password: String) {
        self.password = password
    }
}

// MARK: - Private Constants

extension PasswordEditViewController {
    private struct Constants {
        struct PropertiesContainer {
            static let propertyQuantity: Int = 3
            static let topIndent: CGFloat = 24
            static let leftRightIndent: CGFloat = 20
            static let cornerRadius: CGFloat = 24
        }
        struct  Property {
            struct Title {
                static let fontSize: CGFloat = 16
            }
            
            struct TextField {
                static let fontSize: CGFloat = 20
            }
            
            static let upDownIndent: CGFloat = 7
            static let height: CGFloat = 50
            static let separatorHeight: CGFloat = 2
            static let leftRightIndent: CGFloat = 12
        }
        struct AcceptButton {
            static let height: CGFloat = 50
            static let topIndent: CGFloat = 24
            static let cornerRadius: CGFloat = 10
        }
    }
}
