import UIKit
import PinLayout
 
 
class SomeOneAccountViewController: UIViewController, AlertMessages {
    
    private let backButton = UIButton()
    
    private let headerViewContainer: UIView = UIView()
    
    private let userPhoto: UIImageView = UIImageView()
    private let userName: UILabel = UILabel()
    
    private let button: UIButton = UIButton(type: .system)
    
    private let accountInfo: UIView = UIView()
    private let subscribersLabel: UILabel = UILabel()
    private let subscriptionsLabel: UILabel = UILabel()
    private let bottomLine: UIView = UIView()
    
    private let tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain)
    
    private var someOneAccountPostData: [MyAccountPost] = []
    
    var isSubscribed: Bool = false
    
    var someOneAccountInfo = MyAccountInfo()
    
    var output: SomeOneAccountPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        setupHeaderViewContainer()
        
        setupImage()
        setupUserName()
        setupButton()
        setupSubscribersLabel()
        setupSubscriptionsLabel()
        setupBottomLine()
        setupViews()
        setupTable()
        
        view.backgroundColor = .white
    }
    
    @objc
    func fetchData() {
        checkSubscription()
        output?.userWantsToViewAccountInfo(uid: someOneAccountInfo.uid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    private func checkSubscription() {
        output?.userWantsToCheckSubscription(destinationUID: someOneAccountInfo.uid)
    }
    
    private func configure() {
        setupUserPhoto()
        setupSubscribersAndSubscriptions()
        setupUserNameText()
    }
    
    private func setupViews() {
        [subscribersLabel, subscriptionsLabel].forEach {
            accountInfo.addSubview($0)
        }
        
        [userPhoto, userName, button, accountInfo, bottomLine].forEach {
            headerViewContainer.addSubview($0)
        }
 
        [tableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        tableView.pin
            .top(view.pin.safeArea.top)
            .bottom()
            .horizontally()
        
        headerViewContainer.pin
            .height(Constants.HeaderViewContainer.height)
            .horizontally()
        
        userPhoto.pin
            .hCenter()
            .top(Constants.Photo.topPadding)
            .height(2 * Constants.Photo.radius)
            .width(2 * Constants.Photo.radius)
        
        userName.pin
            .hCenter()
            .top(userPhoto.frame.maxY + Constants.Username.topPadding)
            .width(Constants.Username.width)
            .height(Constants.Username.fontSize)
        
        button.pin
            .hCenter()
            .top(userName.frame.maxY + Constants.Button.topPadding)
            .height(Constants.Button.height)
            .width(Constants.Button.width)
        
        accountInfo.pin
            .top(button.frame.maxY + Constants.AccountInfo.topPadding)
            .hCenter()
            .width(Constants.AccountInfo.width)
            .height(Constants.AccountInfo.fontSize)
        
        subscribersLabel.pin
            .top()
            .hCenter(-Constants.AccountInfo.betweenPanding)
            .width(Constants.SubscribersLabel.width)
            .height(Constants.AccountInfo.fontSize)
        
        subscriptionsLabel.pin
            .top()
            .hCenter(Constants.AccountInfo.betweenPanding)
            .width(Constants.SubscribersLabel.width)
            .height(Constants.AccountInfo.fontSize)
        
        bottomLine.pin
            .horizontally()
            .bottom()
            .height(Constants.BottomLine.width)

    }
    
    private func setupUserPhoto() {
        if let image = someOneAccountInfo.userImage {
            userPhoto.image = UIImage(data: image)
        } else {
            userPhoto.image = UIImage(named: "avatar")
        }
    }
    
    private func setupImage() {
        userPhoto.layer.cornerRadius = Constants.Photo.radius
        userPhoto.layer.masksToBounds = true
        userPhoto.contentMode = .scaleAspectFill
        userPhoto.layer.borderWidth = Constants.Photo.borderWidth
        userPhoto.tintColor = .defaultBlackColor
    }
    
    private func setupUserName() {
        userName.tintColor = .defaultBlackColor
        userName.font = .boldSystemFont(ofSize: Constants.Username.fontSize)
        userName.textAlignment = .center
    }
    
    private func setupUserNameText() {
        userName.text = someOneAccountInfo.userName
    }
    
    private func setupButton() {
        button.titleLabel?.font = .systemFont(ofSize: Constants.Button.fontSize)
        button.layer.cornerRadius = Constants.Button.cornerRadius
                
        button.addTarget(self, action: #selector(didTapButtonSubscribe), for: .touchUpInside)
    }
    
    private func configureButton() {
        if isSubscribed == false {
            button.setTitle(Constants.Button.subscribeText, for: .normal)
            button.backgroundColor = .defaultRedColor
            button.tintColor = .defaultWhiteColor
        } else {
            button.setTitle(Constants.Button.subscribedText, for: .normal)
            button.backgroundColor = .lightGray
            button.tintColor = .defaultBlackColor
        }
    }
    
    @objc
        private func didTapButtonSubscribe() {
            if isSubscribed == false {
                output?.userWantsToBecomeSubscribe(uid: someOneAccountInfo.uid)
                button.setTitle(Constants.Button.subscribedText, for: .normal)
                button.backgroundColor = .lightGray
                button.tintColor = .black
                isSubscribed = true
            } else {
                output?.userWantsToDismissSubscribe(uid: someOneAccountInfo.uid)
                button.setTitle(Constants.Button.subscribeText, for: .normal)
                button.backgroundColor = .defaultRedColor
                button.tintColor = .white
                isSubscribed = false
            }
        }
    
    private func setupSubscribersLabel() {
        subscribersLabel.tintColor = .defaultBlackColor
        subscribersLabel.font = .accountInfo
        subscribersLabel.textAlignment = .right
        
    }
    
    private func setupSubscriptionsLabel() {
        subscriptionsLabel.tintColor = .defaultBlackColor
        subscriptionsLabel.font = .accountInfo
        subscriptionsLabel.textAlignment = .left
    }
    
    private func setupSubscribersAndSubscriptions() {
        subscriptionsLabel.text = "Подписки: " + String(someOneAccountInfo.numberOfSubscriptions)
        subscribersLabel.text = "Подписчики: " + String(someOneAccountInfo.numberOfSubscribers)
    }
    
    private func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.tintColor = .defaultBlackColor
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.isTranslucent = true
        navBar.shadowImage = UIImage()
    }
    
    private func setupHeaderViewContainer() {
        headerViewContainer.backgroundColor = .white
//        setupShadow()
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(SomeOneAccountPostCell.self, forCellReuseIdentifier: "SomeOneAccountPostCell")
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .defaultBackgroundColor
    
        tableView.tableHeaderView = headerViewContainer
    }
    
    private func setupShadow() {
        headerViewContainer.layer.shadowColor = UIColor.darkGray.cgColor
        headerViewContainer.layer.shadowOpacity = Constants.Shadow.Opacity
        headerViewContainer.layer.shadowOffset = .zero
        headerViewContainer.layer.shadowRadius = Constants.Shadow.Radius
    }
    
    private func setupBottomLine() {
        bottomLine.backgroundColor = .defaultBlackColor
    }
}
 
extension SomeOneAccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if someOneAccountPostData[indexPath.row].mainImage != nil {
            return (SomeOneAccountPostCell.Constants.Header.height + SomeOneAccountPostCell.Constants.Display.blockWidth + 2 * SomeOneAccountPostCell.Constants.DefaultPadding.topBottomPadding
                        + 8)
        } else {
            return (SomeOneAccountPostCell.Constants.Header.height +
                        SomeOneAccountPostCell.Constants.SeparatorLine.height +
                        SomeOneAccountPostCell.Constants.MainTitleLabel.fontSize +
                        4 * SomeOneAccountPostCell.Constants.DefaultPadding.topBottomPadding +
                        SomeOneAccountPostCell.Constants.AddressLabel.fontSize +
                        SomeOneAccountPostCell.Constants.HeaderLine.width +
                        SomeOneAccountPostCell.Constants.OpenButton.height)
        }
    }
}
 
extension SomeOneAccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return someOneAccountPostData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SomeOneAccountPostCell") as? SomeOneAccountPostCell
        guard let strongCell = cell else { return UITableViewCell() }
        someOneAccountPostData[indexPath.row].userImageData = someOneAccountInfo.userImage
        cell?.configure(data: someOneAccountPostData[indexPath.row])
        strongCell.openDelegate = self
        return strongCell
    }
}

// MARK: - SomeOneAccountViewController

extension SomeOneAccountViewController: SomeOneAccountViewControllerInput {
    func reloadTableView(accountInfo: MyAccountInfo, accountPosts: [MyAccountPost]) {
        
        someOneAccountInfo = accountInfo
        someOneAccountPostData = accountPosts
        
        configure()
        
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    func fetchSubscription(isSubscribed: Bool) {
        self.isSubscribed = isSubscribed
        configureButton()
    }
}

// MARK: - CellTapButtonDelegate

extension SomeOneAccountViewController: CellTapButtonDelegate {
    func didTapOpen(sender: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let postViewController: PostViewController = PostViewController()
        let title = someOneAccountPostData[indexPath.row].mainTitle + " " + someOneAccountPostData[indexPath.row].address
        postViewController.setup(context: PostContext(
            idPost: someOneAccountInfo.postKeys[indexPath.row],
            keysImages: someOneAccountPostData[indexPath.row].images,
            avatarImage: someOneAccountInfo.userImage,
            username: someOneAccountInfo.userName,
            dateDay: someOneAccountPostData[indexPath.row].date.day,
            dateMonth: someOneAccountPostData[indexPath.row].date.month,
            dateYear: someOneAccountPostData[indexPath.row].date.year,
            title: title,
            comment: someOneAccountPostData[indexPath.row].comment,
            mark: someOneAccountPostData[indexPath.row].mark,
            uid: someOneAccountInfo.uid
        ))
        navigationController?.pushViewController(postViewController, animated: true)
    }
}

// MARK: - private Constants
 
private extension SomeOneAccountViewController {
    private struct Constants {
        struct SubscribersLabel {
            
            static let width: CGFloat = 160
            
        }
        
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
            static let width: CGFloat = 200
            static let topPadding: CGFloat = 6
        }
        
        struct AccountInfo {
            
            static let betweenPanding: CGFloat = 100
            static let topPadding: CGFloat = 18
            static let fontSize: CGFloat = 18
            static let width: CGFloat = 280
            
        }
        
        struct Shadow {
            
            static let Opacity: Float = 1
            static let Radius: CGFloat = 2
            
        }
        
        struct BottomLine {
            static let width: CGFloat = 1
        }
    }
}
