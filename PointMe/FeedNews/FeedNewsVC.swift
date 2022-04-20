import UIKit

class FeedNewsViewController: UIViewController {
    
    private let newsFeedTableView = UITableView()
    
    private let model: FeedNewsModel = FeedNewsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
        appearance.backIndicatorImage.withTintColor(.black)
            appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.titleNavBar
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        title = "PointMe"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(tapped))
        navigationController?.navigationBar.tintColor = .black
        //navigationController?.navigationBar.barTintColor = UIColor.black
        //title.
        
        setupNewsFeedTableView()
        registerCell()
        
        model.getPosts { result in
            switch result {
            case .success():
                print("success download")
                    self.setupsCell()
                break
            case .failure(_):
                print("fail download")
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        newsFeedTableView.pin
            //.center()
            //.height(500)
            //.width(200)
            .horizontally()
            .vertically()
    }
    
    @objc private func tapped() {
        let createPostViewController: CreatingPostViewController = CreatingPostViewController()
        navigationController?.pushViewController(createPostViewController, animated: true)
    }
    
    private func setupNewsFeedTableView() {
        view.addSubview(newsFeedTableView)
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
        //newsFeedTableView.refreshControl?.endRefreshing()
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
        return cell
        //PostPreviewCell().configure(post: posts[indexPath.row])
    }
}

extension FeedNewsViewController: PostPreviewButtonTapDelegate {
    func didTapOpenButton(sender: UITableViewCell) {
        let indexPath = newsFeedTableView.indexPath(for: sender)!
        let onePostViewController: PostViewController = PostViewController()
        let data = model.getPostPreviewModelByIndex(index: indexPath.row)
        
        onePostViewController.setup(context: PostContext(
            keysImages: data.keysImages,
            avatarImage: data.avatarData,
            username: data.username,
            dateDay: data.postDateDay,
            dateMonth: data.postDateMonth,
            dateYear: data.postDateYear,
            title: data.title,
            comment: data.comment,
            mark: data.mark
        ))
        
        navigationController?.pushViewController(onePostViewController, animated: true)
    }
    
    
}

