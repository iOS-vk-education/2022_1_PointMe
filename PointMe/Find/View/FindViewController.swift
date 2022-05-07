import UIKit

class FindViewController: UIViewController {
    
    private lazy var searchController: UISearchController = {
        let searchController: UISearchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        
        return searchController
    }()
    
    
    private lazy var resultSearchTableView: UITableView = {
        let resultSearchTableView: UITableView = UITableView()
        
        resultSearchTableView.delegate = self
        resultSearchTableView.dataSource = self
        resultSearchTableView.register(FindUserCell.self, forCellReuseIdentifier: FindUserCell.idCell)
        resultSearchTableView.separatorStyle = .none
        
        return resultSearchTableView
    }()
    
    
    let model: FindUserModel = FindUserModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Поиск"
        view.backgroundColor = .defaultBackgroundColor
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        [resultSearchTableView].forEach {
            view.addSubview($0)
        }

        setupLayout()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        model.fetchData { [weak self] result in
            switch result {
            case .success():
                self?.resultSearchTableView.reloadData()
            case .failure(_):
                break
            }
        }
    }
    
    
    private func setupLayout() {
        resultSearchTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultSearchTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            resultSearchTableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor
            ),
            resultSearchTableView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor
            ),
            resultSearchTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
        ])
    }
    
    
    private var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? false
    }
    
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
}


extension FindViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text ?? "")
        resultSearchTableView.reloadData()
    }
    
    
    private func filterContentForSearchText(searchText: String) {
        model.filterUserDataBySearchText(searchText: searchText)
    }
}


extension FindViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.heightCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userData = model.getUserDataTupleByIndex(index: indexPath.row, isFiltered: isFiltering)
        // MARK: переход на экран юзера
    }
}


extension FindViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? model.countFilteredUsersData : model.countUsersData
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FindUserCell.idCell, for: indexPath) as? FindUserCell else {
            return UITableViewCell()
        }

        cell.setupCell(context: model.getUserDataByIndex(index: indexPath.row, isFiltered: isFiltering))
        cell.selectionStyle = .none
        
        return cell
    }
}


private extension FindViewController {
    struct Constants {
        struct TableView {
            static let heightCell: CGFloat = 91
        }
    }
}

