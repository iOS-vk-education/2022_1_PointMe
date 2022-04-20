import UIKit
import PinLayout
 
 
class SubAccountViewController: UIViewController {
    
    private let backButton = UIButton(type: .system)
    
    private let headerViewContainer: UIView = UIView()
    
    private let userPhoto: UIImageView = UIImageView()
    private let userName: UILabel = UILabel()
    
    private let button: UIButton = UIButton(type: .system)
    
    private let accountInfo: UIView = UIView()
    private let subscribersLabel: UILabel = UILabel()
    private let subscriptionsLabel: UILabel = UILabel()
    private var type: profileType = .new
    
    private let tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaderViewContainer()
        setupImage()
        setupUserName()
        setupNavigationBar()
        setupButton()
        setupSubscribersLabel()
        setupSubscriptionsLabel()
        setupViews()
        setupTable()
 
        
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        
        setupTableConstraint()
        setupHeaderViewContainerConstraint()
        setupImageConstraint()
        setupUserNameConstraint()
        setupButtonConstraint()
        setupAccountInfoConstraint()
        setupSubscribersLabelConstraint()
        setupSubscriptionsLabelConstraint()
    }
    
    func switchAccountView(type: profileType) {
        self.type = type
    }
    
    private func setupViews() {
        
        [subscribersLabel, subscriptionsLabel].forEach {
            accountInfo.addSubview($0)
        }
        
        [userPhoto, userName, button, accountInfo].forEach {
            headerViewContainer.addSubview($0)
        }
 
        [tableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupImage() {
        
        userPhoto.layer.cornerRadius = Constants.Photo.radius
        userPhoto.layer.masksToBounds = true
        userPhoto.layer.borderWidth = Constants.Photo.borderWidth
        userPhoto.image = UIImage(named: "Jason")
        
    }
    
    private func setupImageConstraint() {
        userPhoto.pin
            .hCenter()
            .top(Constants.Photo.topPadding)
            .height(2 * Constants.Photo.radius)
            .width(2 * Constants.Photo.radius)
        
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
        case .subscribed:
            setupSubscribedButton()
        case .new:
            setupSubscribeButton()
        }
    }
    
    private func setupSubscribedButton() {
        
        button.tintColor = .black
        button.backgroundColor = .subscribedButtonColor
        button.setTitle(Constants.Button.subscribedText, for: .normal)
        
        button.addTarget(self, action: #selector(didTapButtonSubscribe), for: .touchUpInside)
        
    }
    
    
    private func setupSubscribeButton() {
        
        button.tintColor = .white
        button.backgroundColor = .defaultRedColor
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
    private func didTapButtonSubscribe() {
        
        if type == .new {
            button.setTitle(Constants.Button.subscribedText, for: .normal)
            button.backgroundColor = .lightGray
            button.tintColor = .black
            type = .subscribed
        }
        else {
            button.setTitle(Constants.Button.subscribeText, for: .normal)
            button.backgroundColor = .defaultRedColor
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
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.isHidden = true
        
    }
    
    private func setupBackButton() {
        
        backButton.setBackgroundImage(UIImage(systemName: "chevron.left"), for: .normal)
    }
    
    private func setupHeaderViewContainer() {
        
        headerViewContainer.backgroundColor = .white
//        setupShadow()
        
    }
    
    private func setupHeaderViewContainerConstraint() {
        headerViewContainer.pin
            .height(Constants.HeaderViewContainer.height)
            .horizontally()
    }
    
    private func setupTable() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView = headerViewContainer
    }
    
    private func setupTableConstraint() {
        tableView.pin
            .top(view.pin.safeArea.top)
            .bottom()
            .horizontally()
    }
    
    private func setupShadow() {
        
        headerViewContainer.layer.shadowColor = UIColor.darkGray.cgColor
        headerViewContainer.layer.shadowOpacity = Constants.Shadow.Opacity
        headerViewContainer.layer.shadowOffset = Constants.Shadow.Offset
        headerViewContainer.layer.shadowRadius = Constants.Shadow.Radius
        
    }
}
 
extension SubAccountViewController: UITableViewDelegate {
    
}
 
extension SubAccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .defaultBackgroundColor
        return cell
    }
    
    
}
 
private extension SubAccountViewController {
    private struct Constants {
        
        struct Photo {
            
            static let radius: CGFloat = 40
            static let borderWidth: CGFloat  = 1
            static let topPadding: CGFloat = 12
            
        }
        
        struct HeaderViewContainer {
            
            static let height: CGFloat = Constants.Photo.topPadding
                                        + 2 * Constants.Photo.radius
                                        + Constants.Username.topPadding
                                        + Constants.Username.fontSize
                                        + Constants.Button.height
                                        + Constants.Button.topPadding
                                        + Constants.AccountInfo.topPadding
                                        + Constants.AccountInfo.fontSize
                                        + 18
        }
        
        struct Button {
            
            static let subscribeText = "Подписаться"
            static let subscribedText = "Вы подписаны"
            static let editText = "Редактировать"
            static let width: CGFloat = 170
            static let height: CGFloat = 38
            static let cornerRadius: CGFloat = 8
            static let topPadding: CGFloat = 14
            static let fontSize: CGFloat = 16
        }
        
        struct Username {
            
            static let fontSize: CGFloat = 18
            static let textAlignment: NSTextAlignment = .center
            static let width: CGFloat = 200
            static let topPadding: CGFloat = 6
            
        }
        
        struct AccountInfo {
            
            static let betweenPanding: CGFloat = 90
            static let topPadding: CGFloat = 18
            static let fontSize: CGFloat = 18
            
        }
        
        struct Shadow {
            
            static let Opacity: Float = 1
            static let Offset: CGSize = .zero
            static let Radius: CGFloat = 2
            
        }
        
    }
}
 
extension SubAccountViewController {
    enum profileType {
        case subscribed
        case new
    }
}
