//
//  GeopointPlacesViewController.swift
//  PointMe
//
//  Created by Павел Топорков on 28.05.2022.
//  
//

import UIKit

final class GeopointPlacesViewController: UIViewController {
	private let output: GeopointPlacesViewOutput
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(GeopointPlaceCell.self, forCellReuseIdentifier: GeopointPlaceCell.id)
        
        return tableView
    }()

    init(output: GeopointPlacesViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
		super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Обзоры"
        view.addSubview(tableView)
        
        setupLayout()
	}
    
    private func setupLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
}

extension GeopointPlacesViewController: GeopointPlacesViewInput {
    func reloadData() {
        tableView.reloadData()
    }
}

extension GeopointPlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension GeopointPlacesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.countPosts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeopointPlaceCell.id, for: indexPath) as? GeopointPlaceCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.setup(model: output.getPost(by: indexPath.row), index: indexPath.row)
        
        return cell
    }
}

extension GeopointPlacesViewController: GeoplacePostCellDelegate {
    func didTapButton(senderIndex: Int?) {
        if let senderIndex = senderIndex {
            output.didTapButtonShowPost(index: senderIndex)
        }
    }
}
