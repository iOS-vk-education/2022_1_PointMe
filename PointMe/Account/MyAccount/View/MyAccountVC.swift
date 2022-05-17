import UIKit
import PinLayout
 
 
class MyAccountViewController: UIViewController, AlertMessages {
    
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
    
    private var myAccountPostData: [MyAccountPost] = []
    
    var myAccountInfo = MyAccountInfo()
    
    var output: MyAccountPresenter?
    
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
        output?.userWantsToViewMyAccountInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
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
        if let image = myAccountInfo.userImage {
            userPhoto.image = UIImage(data: image)
        } else {
            userPhoto.image = UIImage(systemName: "person")
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
        userName.text = myAccountInfo.userName
    }
    
    private func setupButton() {
        button.titleLabel?.font = .systemFont(ofSize: Constants.Button.fontSize)
        button.layer.cornerRadius = Constants.Button.cornerRadius
        setupEditButton()
    }
    
    private func setupEditButton() {
        button.tintColor = .defaultWhiteColor
        button.backgroundColor = .defaultBlackColor
        button.setTitle(Constants.Button.editText, for: .normal)
        
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
        subscriptionsLabel.text = "Подписки: " + String(myAccountInfo.numberOfSubscriptions)
        subscribersLabel.text = "Подписчики: " + String(myAccountInfo.numberOfSubscribers)
        
    }
    
    private func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.isHidden = true
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
        
        tableView.register(MyAccountPostCell.self, forCellReuseIdentifier: "MyAccountPostCell")
        
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
 
extension MyAccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if myAccountPostData[indexPath.row].mainImage != nil {
            return (MyAccountPostCell.Constants.Header.height
                        + MyAccountPostCell.Constants.Display.blockWidth
                        + 2 * MyAccountPostCell.Constants.DefaultPadding.topBottomPadding
                        + 8)
        } else {
            return (MyAccountPostCell.Constants.Header.height
                        + MyAccountPostCell.Constants.SeparatorLine.height
                        + MyAccountPostCell.Constants.MainTitleLabel.fontSize
                        + 4 * MyAccountPostCell.Constants.DefaultPadding.topBottomPadding
                        + MyAccountPostCell.Constants.AddressLabel.fontSize
                        + MyAccountPostCell.Constants.HeaderLine.width
                        + MyAccountPostCell.Constants.OpenButton.height
            )
        }
    }
}
 
extension MyAccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAccountPostData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountPostCell") as? MyAccountPostCell
        guard let strongCell = cell else { return UITableViewCell() }
        myAccountPostData[indexPath.row].userImageData = myAccountInfo.userImage
        cell?.configure(data: myAccountPostData[indexPath.row])
        strongCell.delegate = self
        strongCell.openDelegate = self
        return strongCell
    }
}

// MARK: - MyAccountViewControllerInput

extension MyAccountViewController: MyAccountViewControllerInput {
    func reloadTableView(accountInfo: MyAccountInfo, accountPosts: [MyAccountPost]) {
        myAccountInfo = accountInfo
        myAccountPostData = accountPosts
        configure()
        
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - CellDeleteDelegate

extension MyAccountViewController: CellDeleteDelegate {
    func deleteCell(sender: UITableViewCell) {
        showDeleteAlertTwoButtons(forTitleText: "Подтверждение", forBodyText: "Вы уверены, что хотите удалить пост?", viewController: self) {
            guard let indexPath = self.tableView.indexPath(for: sender) else { return }
            let postKey = self.myAccountInfo.postKeys[indexPath.row]
            
            self.myAccountInfo.postKeys.remove(at: indexPath.row)
            
            self.output?.userWantsToRemovePost(postKey: postKey, postKeys:  self.myAccountInfo.postKeys, imageKey: self.myAccountPostData[indexPath.row].images)

            self.myAccountPostData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - CellTapButtonDelegate

extension MyAccountViewController: CellTapButtonDelegate {
    func didTapOpen(sender: UITableViewCell) {
        let indexPath = tableView.indexPath(for: sender)!
        let postViewController: PostViewController = PostViewController()
        let title = myAccountPostData[indexPath.row].mainTitle + " " + myAccountPostData[indexPath.row].address
        postViewController.setup(context: PostContext(
            idPost: myAccountInfo.postKeys[indexPath.row],
            keysImages: myAccountPostData[indexPath.row].images,
            avatarImage: myAccountInfo.userImage,
            username: myAccountInfo.userName,
            dateDay: myAccountPostData[indexPath.row].date.day,
            dateMonth: myAccountPostData[indexPath.row].date.month,
            dateYear: myAccountPostData[indexPath.row].date.year,
            title: title,
            comment: myAccountPostData[indexPath.row].comment,
            mark: myAccountPostData[indexPath.row].mark,
            uid: myAccountInfo.uid
        ))
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    
}

// MARK: - private Constants
 
private extension MyAccountViewController {
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
