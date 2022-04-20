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
                DispatchQueue.main.async {
                    self.setupsCell()
                }
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
        print(432)
    }
    private func setupNewsFeedTableView() {
        view.addSubview(newsFeedTableView)
        newsFeedTableView.backgroundColor = .defaultBackgroundColor
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
    }
    
    private func registerCell() {
        newsFeedTableView.register(PostPreviewCell.self, forCellReuseIdentifier: "PostPreviewCell")
    }
    
    private func setupsCell() {
        newsFeedTableView.reloadData()
    }
    
}

extension FeedNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if model.checkIsExistImageByIndex(index: indexPath.row) {
            return 206
        }
        else {
            return 251
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
        cell.configure(post: model.getPostPreviewModelByIndex(index: indexPath.row))
        cell.backgroundColor = .defaultBackgroundColor
        return cell
        //PostPreviewCell().configure(post: posts[indexPath.row])
    }
    
    
}

