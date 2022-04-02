import UIKit
import PinLayout


class AccountViewController: UIViewController {
    
    private let headerViewContainer: UIView = UIView()
    
    private let userPhoto: UIImageView = UIImageView()
    private let userName: UILabel = UILabel()
    
    private let button: UIButton = UIButton(type: .system)
    
    private let accountInfo: UIView = UIView()
    private let subscribersLabel: UILabel = UILabel()
    private let subscriptionsLabel: UILabel = UILabel()
    
    private var type: profileType = .my
    
    func switchAccountView(type: profileType) {
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImage()
        setupUserName()
        setupNavigationBar()
        setupButton()
        setupSubscribersLabel()
        setupSubscriptionsLabel()
        
        view.backgroundColor = .defaultBackgroundColor
        
        view.addSubview(headerViewContainer)
        view.addSubview(accountInfo)
        [userPhoto, userName, button].forEach {
            headerViewContainer.addSubview($0)
        }
        
        [subscribersLabel, subscriptionsLabel].forEach {
            accountInfo.addSubview($0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        setupHeaderViewContainer()
        setupImageConstraint()
        setupUserNameConstraint()
        setupButtonConstraint()
        setupAccountInfoConstraint()
        setupSubscribersLabelConstraint()
        setupSubscriptionsLabelConstraint()
        
    }
    
    private func setupImage() {
        
        userPhoto.layer.cornerRadius = Constants.Photo.radius / 2
        userPhoto.layer.masksToBounds = true
        userPhoto.layer.borderWidth = Constants.Photo.borderWidth
        userPhoto.image = UIImage(named: "Jason")
        
    }
    
    private func setupImageConstraint() {
        
        guard let navBarHeaight = navigationController?.navigationBar.frame.height else { return }
        userPhoto.pin
            .hCenter()
            .top(view.pin.safeArea.top - navBarHeaight + Constants.Photo.topPadding)
            .height(Constants.Photo.radius)
            .width(Constants.Photo.radius)
        
    }
    
    private func setupUserNameConstraint() {
        
        userName.pin
            .hCenter()
            .top(userPhoto.frame.maxY + Constants.Username.topPadding)
            .width(Constants.Username.width)
            .height(Constants.Username.fontSize)
        
    }
    
    private func setupUserName() {
        
        //Запрос в БД
        userName.text = "Jason"
        userName.tintColor = .defaultBlackColor
        userName.font = .boldSystemFont(ofSize: 18)
        userName.textAlignment = Constants.Username.textAlignment
        
    }
    
    private func setupButton() {
        
        button.titleLabel?.font = .systemFont(ofSize: Constants.Button.fontSize)
        button.layer.cornerRadius = Constants.Button.cornerRadius
        
        switch type {
        case .my:
            setupEditButton()
        case .subscribed:
            setupSubscribedButton()
        case .new:
            setupSubscribeButton()
        }
    }
    
    private func setupEditButton() {
        
        button.tintColor = .white
        button.backgroundColor = .defaultBlackColor
        button.setTitle(Constants.Button.editText, for: .normal)
        
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
    }
    
    private func setupSubscribedButton() {
        
        button.tintColor = .black
        button.backgroundColor = .subscribedButtonColor
        button.setTitle(Constants.Button.subscribedText, for: .normal)
        
        button.addTarget(self, action: #selector(didTapButtonSubscribe), for: .touchUpInside)
        
    }
    
    
    private func setupSubscribeButton() {
        
        button.tintColor = .white
        button.backgroundColor = .subscribeButtonColor
        button.setTitle(Constants.Button.subscribeText, for: .normal)
        
        button.addTarget(self, action: #selector(didTapButtonSubscribe), for: .touchUpInside)
        
    }
    
    private func setupButtonConstraint() {
        
        button.pin
            .hCenter()
            .top(userName.frame.maxY + Constants.Button.topPadding)
            .height(Constants.Button.height)
            .width(Constants.Button.width)
    }
    
    @objc
    private func didTapEditButton() {
        
        let viewController = AccountViewController()
        viewController.switchAccountView(type: .subscribed)
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @objc
    private func didTapButtonSubscribe() {
        
        if type == .new {
            button.setTitle(Constants.Button.subscribedText, for: .normal)
            button.backgroundColor = .lightGray
            button.tintColor = .black
            type = .subscribed
        }
        else {
            button.setTitle(Constants.Button.subscribeText, for: .normal)
            button.backgroundColor = .subscribeButtonColor
            button.tintColor = .white
            type = .new
        }
    }
    
    private func isSubscribeQuery() -> Bool{
        
        //Запрос в БД
        return false
        
    }
    
    private func setupAccountInfoConstraint() {
        
        accountInfo.pin
            .top(button.frame.maxY + Constants.AccountInfo.topPadding)
            .hCenter()
            .width(280)
            .height(Constants.AccountInfo.fontSize)
    }
    
    private func setupSubscribersLabel() {
        
        let subscribesNum = numOfSubscribersQuery()
        subscribersLabel.text = "Подписчики: " + String(subscribesNum)
        subscribersLabel.tintColor = .defaultBlackColor
        subscribersLabel.font = .accountInfo
        subscribersLabel.textAlignment = .right
        
    }
    
    private func numOfSubscribersQuery() -> Int {
        
        //Запрос БД
        return 120
    }
    
    private func setupSubscribersLabelConstraint() {
        
        subscribersLabel.pin
            .top()
            .hCenter(-Constants.AccountInfo.betweenPanding)
            .width(140)
            .height(Constants.AccountInfo.fontSize)
    }
    
    private func setupSubscriptionsLabel() {
        
        subscriptionsLabel.text = "Подписки: " + "100"
        subscriptionsLabel.tintColor = .defaultBlackColor
        subscriptionsLabel.font = .accountInfo
        subscriptionsLabel.textAlignment = .left
    }
    
    private func setupSubscriptionsLabelConstraint() {
        
        subscriptionsLabel.pin
            .top()
            .hCenter(Constants.AccountInfo.betweenPanding)
            .width(140)
            .height(Constants.AccountInfo.fontSize)
        
    }
    
    
    private func setupNavigationBar() {
        
        let navBar = navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.topItem?.backButtonTitle = ""
        navBar?.tintColor = .navBarItemColor
        
    }
    
    private func setupHeaderViewContainer() {
        
        headerViewContainer.backgroundColor = .white
        headerViewContainer.pin
            .top()
            .height(Constants.HeaderViewContainer.height)
            .horizontally()
        
        setupShadow()
        
    }
    
    private func setupShadow() {
        
        headerViewContainer.layer.shadowColor = UIColor.darkGray.cgColor
        headerViewContainer.layer.shadowOpacity = Constants.Shadow.Opacity
        headerViewContainer.layer.shadowOffset = Constants.Shadow.Offset
        headerViewContainer.layer.shadowRadius = Constants.Shadow.Radius
        
    }
}

private extension AccountViewController {
    private struct Constants {
        
        struct Photo {
            
            static let radius: CGFloat = 80
            static let borderWidth: CGFloat  = 1
            static let topPadding: CGFloat = 15
            
        }
        
        struct HeaderViewContainer {
            
            static let height: CGFloat  = 270
        }
        
        struct Button {
            
            static let subscribeText = "Подписаться"
            static let subscribedText = "Вы подписаны"
            static let editText = "Редактировать"
            static let width: CGFloat = 170
            static let height: CGFloat = 38
            static let cornerRadius: CGFloat = 8
            static let topPadding: CGFloat = 12
            static let fontSize: CGFloat = 16
        }
        
        struct Username {
            
            static let fontSize: CGFloat = 18
            static let textAlignment: NSTextAlignment = .center
            static let width: CGFloat = 200
            static let topPadding: CGFloat = 8
            
        }
        
        struct AccountInfo {
            
            static let betweenPanding: CGFloat = 90
            static let topPadding: CGFloat = 16
            static let fontSize: CGFloat = 16
            
        }
        
        struct Shadow {
            
            static let Opacity: Float = 1
            static let Offset: CGSize = .zero
            static let Radius: CGFloat = 2
            
        }
        
    }
}

extension AccountViewController {
    enum profileType {
        case my
        case subscribed
        case new
    }
}
