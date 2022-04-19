import UIKit

class FeedNewsViewController: UIViewController {
    
    private let newsFeedTableView = UITableView()
    private let posts: [PostPreviewModel] = [
        PostPreviewModel(avatarImage: nil, username: "username1", postDate: "17 апреля 2022 года", postImage: "star.square", numberOfImages: 2, title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor", location: "СолнцеЛокация", mark: 5),
        PostPreviewModel(avatarImage: "person.circle.fill", username: "username2", postDate: "17 апреля 2022 года", postImage: nil, numberOfImages: 0, title: "Ut enim ad minim veniam, quis nostrud exercitation ullamco", location: "ВенераЛокация", mark: 4),
        PostPreviewModel(avatarImage: nil, username: "username3", postDate: "17 апреля 2022 года", postImage: "star.square", numberOfImages: 3, title: "Duis aute irure dolor in reprehenderit", location: "ЗемляЛокация", mark: 5),
        PostPreviewModel(avatarImage: nil, username: "username4", postDate: "17 апреля 2022 года", postImage: "star.square", numberOfImages: 1, title: "Excepteur sint occaecat cupidatat non proident", location: "СатурнЛокация", mark: 3),
        PostPreviewModel(avatarImage: "person.circle.fill", username: "username5", postDate: "17 апреля 2022 года", postImage: nil, numberOfImages: 0, title: "Sunt in culpa qui officia deserunt", location: "ЮпитерЛокация", mark: 2)
    ]
    
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
    
}

extension FeedNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if posts[indexPath.row].postImage == nil {
            return 206
        }
        else {
            return 251
        }
        //300
    }
}

extension FeedNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsFeedTableView.dequeueReusableCell(withIdentifier: "PostPreviewCell", for: indexPath) as? PostPreviewCell else {
            fatalError()
        }
        cell.configure(post: posts[indexPath.row])
        cell.backgroundColor = .defaultBackgroundColor
        return cell
        //PostPreviewCell().configure(post: posts[indexPath.row])
    }
    
    
}

