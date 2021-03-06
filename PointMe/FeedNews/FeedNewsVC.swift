import UIKit

class FeedNewsViewController: UIViewController {
    
    /*
    private lazy var loadingAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Ожидание",
            message: "Пожалуйста подождите...",
            preferredStyle: UIAlertController.Style.alert
        )
        
        let loadingIndicator = UIActivityIndicatorView(
            frame: CGRect(
                x: 10,
                y: 5,
                width: 50,
                height: 50
            )
        )
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        
        return alert
    }()
    */
    
    private let newsFeedTableView = UITableView()
    
    private let model: FeedNewsModel = FeedNewsModel()
    
    private var isLoadingStartData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        title = "PointMe"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(tapped))
        navigationController?.navigationBar.tintColor = .black
        
        setupNewsFeedTableView()
        registerCell()
        
        newsFeedTableView.refreshControl?.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
        appearance.backIndicatorImage.withTintColor(.black)
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.titleNavBar
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isLoadingStartData {
            isLoadingStartData.toggle()
            updateRequestData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        newsFeedTableView.pin
            .all()
    }
    
    @objc private func tapped() {
        let createPostViewController: CreatingPostViewController = CreatingPostViewController()
        navigationController?.pushViewController(createPostViewController, animated: true)
    }
    
    private func setupNewsFeedTableView() {
        view.addSubview(newsFeedTableView)
        setupRefreshControll()
        newsFeedTableView.backgroundColor = .defaultBackgroundColor
        newsFeedTableView.separatorStyle = .none
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
    }
    
    private func registerCell() {
        newsFeedTableView.register(PostPreviewCell.self, forCellReuseIdentifier: "PostPreviewCell")
    }
    
    private func setupsCell() {
        newsFeedTableView.reloadData()
    }
    
    private func setupRefreshControll() {
        let refreshControl = UIRefreshControl()

        refreshControl.addTarget(self, action: #selector(updateRequestData), for: .valueChanged)

        newsFeedTableView.refreshControl = refreshControl
    }
    
    
    @objc func updateRequestData() {
        //self.present(loadingAlert, animated: true, completion: nil)
        model.getPosts { [weak self] result in
            switch result {
            case .success():
                print("success download")
                //self?.loadingAlert.dismiss(animated: true, completion: nil)
                self?.setupsCell()
                break
            case .failure(_):
                print("fail download!!!!")
                //self?.loadingAlert.dismiss(animated: true, completion: nil)
                self?.setupsCell()
                break
            }
            self?.newsFeedTableView.refreshControl?.endRefreshing()
        }
    }
    
}

extension FeedNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if model.checkIsExistImageByIndex(index: indexPath.row) {
            return 251
        }
        else {
            return 206
        }
    }
}

extension FeedNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.countPosts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsFeedTableView.dequeueReusableCell(withIdentifier: "PostPreviewCell", for: indexPath) as? PostPreviewCell else {
            fatalError()
        }
        let post: PostPreviewModel = model.getPostPreviewModelByIndex(index: indexPath.row)
        cell.configure(post: post)
        cell.selectionStyle = .none
        cell.backgroundColor = .defaultBackgroundColor
        cell.delegateTapButton = self
        cell.delegateTapAvatar = self
        return cell
    }
}

extension FeedNewsViewController: PostPreviewButtonTapDelegate {
    func didTapOpenButton(sender: UITableViewCell) {
        guard let indexPath = newsFeedTableView.indexPath(for: sender) else {
            print("cannot find indexPath for cell")
            return
        }
        let onePostViewController: PostViewController = PostViewController()
        let data = model.getPostPreviewModelByIndex(index: indexPath.row)
        
        onePostViewController.setup(context: PostContext(
            idPost: data.postId,
            keysImages: data.keysImages,
            avatarImage: data.avatarData,
            username: data.username,
            dateDay: data.postDateDay,
            dateMonth: data.postDateMonth,
            dateYear: data.postDateYear,
            title: data.title,
            comment: data.comment,
            mark: data.mark,
            uid: data.uid
        ))
        
        navigationController?.pushViewController(onePostViewController, animated: true)
    }
}

extension FeedNewsViewController: TapAvatarDelegate {
    func didTapAvatar(uid: String) {
        let builder = SomeOneAccountBuilder()
        let viewController = builder.build(uid: uid)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

