import UIKit
import Firebase


final class ProfileEditViewController: UIViewController, AlertMessages {
    
    private let headContainer: UIView = UIView()
    
    private let avatarView: UIImageView = UIImageView()
    private let editButton: UIButton = UIButton(type: .system)
    
    private let propertiesContainer: UIView = UIView()
    
    private var propertyContainer: [UIView] = []
    private var property: [(title: UILabel, textField: UITextField, separator: UIView)] = []
    
    private let acceptButton: UIButton = UIButton(type: .system)
    
    private let imagePicker: UIImagePickerController = UIImagePickerController()
    
    private let titles: [String] = ["Имя", "Почта"]
    private var information: (username: String, email: String, image: Data?, imageKey: String) = ("", "", nil, "")
    
    private var avatarFlag: Bool = false
    
    var model: ProfileEditViewControllerOutput?
    
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
        title = "Профиль"
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
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
            
            container.backgroundColor = .none
            
            separator.backgroundColor = .defaultBackgroundColor
            
            propertyContainer.append(container)
            propertiesContainer.layer.cornerRadius = Constants.PropertiesContainer.cornerRadius
            property.append((label, textField, separator))
        }
        
        avatarView.layer.cornerRadius = Constants.HeadContainer.height / 2
        avatarView.layer.borderColor = UIColor.defaultBlackColor.cgColor
        avatarView.layer.borderWidth = Constants.HeadContainer.avatarBorderWidth
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleAspectFill
        avatarView.tintColor = .defaultBlackColor
        
        editButton.backgroundColor = .defaultBlackColor
        editButton.layer.cornerRadius = Constants.EditButton.cornerRadius
        editButton.setTitle("Изменить фото профиля", for: .normal)
        editButton.setTitleColor(.defaultWhiteColor, for: .normal)
        editButton.titleLabel?.font = .profileEditAvatarButton
        editButton.addTarget(self, action: #selector(tapEditButton), for: .touchUpInside)
        
        acceptButton.backgroundColor = .defaultBlackColor
        acceptButton.layer.cornerRadius = Constants.AcceptButton.cornerRadius
        acceptButton.setTitle("Применить", for: .normal)
        acceptButton.setTitleColor(.defaultWhiteColor, for: .normal)
        acceptButton.addTarget(self, action: #selector(changeInfo), for: .touchUpInside)
        
        propertiesContainer.backgroundColor = .defaultWhiteColor
    }
    
    private func configureProperties() {
        property[0].textField.text = information.username
        property[0].textField.placeholder = information.username
        property[1].textField.text = information.email
        property[1].textField.placeholder = information.email
        if let image = information.image {
            avatarView.image = UIImage(data: image)
        } else {
            avatarView.image = UIImage(systemName: "person")
        }
    }
    
    private func setupView() {
        [avatarView, editButton].forEach {
            headContainer.addSubview($0)
        }
        
        for i in 0..<Constants.PropertiesContainer.propertyQuantity {
            propertyContainer[i].addSubview(property[i].title)
            propertyContainer[i].addSubview(property[i].textField)
            propertyContainer[i].addSubview(property[i].separator)
        }
        
        propertyContainer.forEach {
            propertiesContainer.addSubview($0)
        }
        
        [headContainer, propertiesContainer, acceptButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        headContainer.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        propertiesContainer.translatesAutoresizingMaskIntoConstraints = false
        propertyContainer[0].translatesAutoresizingMaskIntoConstraints = false
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.HeadContainer.topIndent),
            headContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.HeadContainer.leftRightIndent),
            headContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.HeadContainer.leftRightIndent),
            headContainer.heightAnchor.constraint(equalToConstant: Constants.HeadContainer.height),
            
            avatarView.leftAnchor.constraint(equalTo: headContainer.leftAnchor),
            avatarView.topAnchor.constraint(equalTo: headContainer.topAnchor),
            avatarView.bottomAnchor.constraint(equalTo: headContainer.bottomAnchor),
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor),
            
            editButton.leftAnchor.constraint(equalTo: avatarView.rightAnchor, constant: Constants.EditButton.leftIndent),
            editButton.rightAnchor.constraint(equalTo: headContainer.rightAnchor),
            editButton.centerYAnchor.constraint(equalTo: headContainer.centerYAnchor),
            editButton.heightAnchor.constraint(equalToConstant: Constants.HeadContainer.height / 2),
            
            propertiesContainer.topAnchor.constraint(equalTo: headContainer.bottomAnchor, constant: Constants.PropertiesContainer.topIndent),
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
    
    private func getInfo() {
        model?.getInfo()
    }
    
    @objc
    private func tapEditButton() {
        present(imagePicker, animated: true)
    }
    
    @objc
    private func changeInfo() {
        var username: String? = nil
        var email: String? = nil
        var avatar: Data? = nil
        if (property[0].textField.text != property[0].textField.placeholder && property[0].textField.text != "") {
            username = property[0].textField.text
        }
        if (property[1].textField.text != property[1].textField.placeholder && property[1].textField.text != "") {
            email = property[0].textField.text
        }
        if (avatarFlag) {
            avatar = information.image
        }
        
        model?.changeInfo(username: username, email: email, avatar: avatar, avatarKey: information.imageKey)
    }
    
}

// MARK: - ProfileEditViewControllerInput

extension ProfileEditViewController : ProfileEditViewControllerInput {
    func makeAlert(forTitleText: String, forBodyText: String) {
        showWarningAlert(forTitleText: forTitleText, forBodyText: forBodyText, viewController: self)
    }
    
    func fetchInfo(username: String, email: String, image: Data?, imageKey: String) {
        information.username = username
        information.email = email
        information.image = image
        information.imageKey = imageKey
        configureProperties()
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension ProfileEditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
            let imageName = UUID().uuidString


        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            avatarFlag = true
            avatarView.image = UIImage(data: jpegData)
            information.image = jpegData
            if information.imageKey.isEmpty {
                information.imageKey = imageName
            }
        }
        
        dismiss(animated: true)
    }
    
    
}

// MARK: - Private Constants

extension ProfileEditViewController {
    private struct Constants {
        struct HeadContainer {
            static let topIndent: CGFloat = 24
            static let leftRightIndent: CGFloat = 38
            static let height: CGFloat = 90
            static let cornerRadius: CGFloat = 10
            static let avatarBorderWidth: CGFloat = 1
        }
        struct EditButton {
            static let leftIndent: CGFloat = 40
            static let borderWidth: CGFloat = 1
            static let cornerRadius: CGFloat = 10
        }
        struct PropertiesContainer {
            static let propertyQuantity: Int = 2
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
            static let topIndent: CGFloat = 20
            static let cornerRadius: CGFloat = 10
        }
    }
}
