import UIKit
import PinLayout
 
 
class MyAccountViewController: UIViewController {
    
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
    
//    private var accountPostData: [MyAccountPost] = [MyAccountPost(userImage: "Jason",
//                                                               userName: "Jason",
//                                                               date: MyAccountPostDate(day: 20,
//                                                                                       month: 10,
//                                                                                       year: 2020),
//                                                               mainImage: "Jason",
//                                                               numberOfImages: 2,
//                                                               mainTitle: "Statham Face",
//                                                               address: "New York, USA",
//                                                               mark: 4)]
    
    var myAccountInfo = MyAccountInfo()
    
    var output: MyAccountPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupHeaderViewContainer()
//        setupNavigationBar()
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
    
    @objc func fetchData() {
        
        output.userWantsToViewAccountInfo() { [self] data in
            let group = DispatchGroup()
            let lock = NSLock()
            
            myAccountInfo = data
            
            if(myAccountInfo.userImageKey != "") {
                group.enter()
                output.userWantsToViewImage(destination: "avatars", postImageKey: myAccountInfo.userImageKey) { dataImage in
                    myAccountInfo.userImage = dataImage
                    group.leave()
                }
            }

            for i in 0..<myAccountInfo.postKeys.count {
                group.enter()
                output.userWantsToViewAccountPosts(userName: myAccountInfo.userName,
                                                   userImage: myAccountInfo.userImageKey,
                                                   postKey: myAccountInfo.postKeys[i]) { post in
                    lock.lock()
                    myAccountPostData.insert(post, at: i)
                    lock.unlock()
                    if (post.images[0] != "") {
                        output.userWantsToViewImage(destination: "posts",postImageKey: post.images[0]) { dataImage in
                            lock.lock()
                            myAccountPostData[i].mainImage = dataImage
                            lock.unlock()
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                setupUserPhoto()
                tableView.refreshControl?.endRefreshing()
                tableView.reloadData()
                tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
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
        setupBottomLineConstraint()
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
    
    private func setupUserPhoto() {
        if let image = myAccountInfo.userImage {
            userPhoto.image = UIImage(data: image)
        } else {
            userPhoto.tintColor = .defaultBlackColor
            userPhoto.image = UIImage(systemName: "person")
        }
    }
    
    private func setupImage() {
        
        userPhoto.layer.cornerRadius = Constants.Photo.radius
        userPhoto.layer.masksToBounds = true
        userPhoto.layer.borderWidth = Constants.Photo.borderWidth
        userPhoto.tintColor = .defaultBlackColor
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
        setupEditButton()
    }
    
    private func setupEditButton() {
        
        button.tintColor = .defaultWhiteColor
        button.backgroundColor = .defaultBlackColor
        button.setTitle(Constants.Button.editText, for: .normal)
        
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
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
        
        let viewController = SubAccountViewController()
        navigationController?.pushViewController(viewController, animated: true)
        
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
            .width(160)
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
            .width(160)
            .height(Constants.AccountInfo.fontSize)
        
    }
    
    private func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.isHidden = true
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(MyAccountPostCell.self, forCellReuseIdentifier: "MyAccountPostCell")
        
        tableView.rowHeight = 70 + UIScreen.main.bounds.width / 2 - 1.5 * 12 + 2 * 12 + 8
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .defaultBackgroundColor
//        uploadAccountPostData()
    
        tableView.tableHeaderView = headerViewContainer
    }
    
    private func uploadAccountPostData() {
        
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
    
    private func setupBottomLineConstraint() {
        bottomLine.pin
            .horizontally()
            .bottom()
            .height(Constants.BottomLine.width)
    }
    
    private func setupBottomLine() {
        bottomLine.backgroundColor = .defaultBlackColor
    }
}
 
extension MyAccountViewController: UITableViewDelegate {
    
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

extension MyAccountViewController: MyAccountViewControllerInput {
    func reloadTableView() {
    }
}

extension MyAccountViewController: CellDeleteDelegate {
    func deleteCell(sender: UITableViewCell) {
        let indexPath = tableView.indexPath(for: sender)!
        myAccountPostData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension MyAccountViewController: CellTapButtonDelegate {
    func didTapOpen(sender: UITableViewCell) {
        let indexPath = tableView.indexPath(for: sender)!
        let postViewController: PostViewController = PostViewController()
        let title = myAccountPostData[indexPath.row].mainTitle + " " + myAccountPostData[indexPath.row].address
        //myAccountPostData[indexPath.row].
        postViewController.setup(context: PostContext(
            keysImages: myAccountPostData[indexPath.row].images,
            avatarImage: myAccountInfo.userImage,
            username: myAccountInfo.userName,
            dateDay: myAccountPostData[indexPath.row].date.day,
            dateMonth: myAccountPostData[indexPath.row].date.month,
            dateYear: myAccountPostData[indexPath.row].date.year,
            title: title,
            comment: myAccountPostData[indexPath.row].comment,
            mark: myAccountPostData[indexPath.row].mark
        ))
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    
}
 
private extension MyAccountViewController {
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
            
            static let betweenPanding: CGFloat = 100
            static let topPadding: CGFloat = 18
            static let fontSize: CGFloat = 18
            
        }
        
        struct Shadow {
            
            static let Opacity: Float = 1
            static let Offset: CGSize = .zero
            static let Radius: CGFloat = 2
            
        }
        
        struct BottomLine {
            static let width: CGFloat = 1
        }
        
    }
}
