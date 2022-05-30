import UIKit
import Firebase

final class SettingsViewController: UIViewController, AlertMessages {
    
    private let pointsContainer: UIView = UIView()
    private var points: [UIButton] = []
    private var separator: UIView = UIView()
    private let exitButton: UIButton = UIButton()
    
    private let pointsText: [String] = ["Редактировать профиль", "Сменить пароль"]
    
    var accountInfo: MyAccountInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProperties()
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        points.forEach {
            pointsContainer.addSubview($0)
        }
        
        pointsContainer.addSubview(separator)
        
        [pointsContainer, exitButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupProperties() {
        
        for i in 0...1 {
            let temp = UIButton(type: .system)
            temp.backgroundColor = .none
            temp.setTitleColor(.defaultBlackColor, for: .normal)
            temp.contentHorizontalAlignment = .leading
            temp.titleLabel?.font = .settingsTitle
            temp.setTitle(pointsText[i], for: .normal)
            points.append(temp)
        }
        
        points[0].addTarget(self, action: #selector(didTapEditProfile), for: .touchUpInside)
        
        exitButton.backgroundColor = .defaultBlackColor
        exitButton.setTitleColor(.defaultWhiteColor, for: .normal)
        exitButton.layer.cornerRadius = 12
        exitButton.setTitle("Выйти", for: .normal)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        
        pointsContainer.backgroundColor = .defaultWhiteColor
        pointsContainer.layer.cornerRadius = 24
        
        separator.backgroundColor = .defaultBackgroundColor
        
        navigationController?.navigationBar.backgroundColor = .defaultWhiteColor
        navigationController?.navigationBar.tintColor = .defaultBlackColor
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.standartTitleNavBar]
        
        view.backgroundColor = .defaultBackgroundColor
        
        title = "Настройки"
    }
    
    @objc
    private func didTapExitButton() {
        showDestructiveAlertTwoButtons(forTitleText: "Внимание!", forBodyText: "Вы уверены, что хотите выйти из аккаунта", destructiveText: "Выйти", cancelText: "Отмена", viewController: self) {
            let authController = AuthNavigationController(rootViewController: SignInViewController())
            authController.modalPresentationStyle = .fullScreen
            authController.modalTransitionStyle = .flipHorizontal
            DatabaseManager.shared.signOut(completion: {
                self.present(authController, animated: true)
            })
        }
    }
    
    @objc
    private func didTapEditProfile() {
        let viewController = ProfileEditViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupConstraints() {
        
        pointsContainer.pin
            .top(view.pin.safeArea.top + Constants.Points.topIndent)
            .height(2 * Constants.Points.height + Constants.Points.separatorHeight)
            .horizontally(Constants.Points.containerBetweenIndent)
        
        points[0].pin
            .top()
            .horizontally(Constants.Points.pointsBetweenIndent)
            .height(Constants.Points.height)
        
        for i in 1..<Constants.Points.numberOfPoints {
            separator.pin
                .below(of: points[i-1])
                .horizontally(Constants.Points.pointsBetweenIndent)
                .height(Constants.Points.separatorHeight)
            
            points[i].pin
                .below(of: points[i-1])
                .marginTop(Constants.Points.separatorHeight)
                .horizontally(Constants.Points.pointsBetweenIndent)
                .height(Constants.Points.height)
        }
        
        exitButton.pin
            .below(of: points[Constants.Points.numberOfPoints-1])
            .marginTop(Constants.Points.topIndent)
            .horizontally(Constants.Points.containerBetweenIndent)
            .height(Constants.Button.height)
    }
}

// MARK: - Private Constants

extension SettingsViewController {
    private struct Constants {
        struct Points {
            static let numberOfPoints = 2
            static let height: CGFloat = 65
            static let topIndent: CGFloat = 30
            static let containerBetweenIndent: CGFloat = 18
            static let separatorHeight: CGFloat = 1
            static let pointsBetweenIndent: CGFloat = 12
        }
        struct Button {
            static let height: CGFloat = 60
        }
    }
}
