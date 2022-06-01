//
//  MapRouter.swift
//  PointMe
//
//  Created by Павел Топорков on 28.05.2022.
//  
//

import UIKit

final class MapRouter {
    var viewController: UIViewController?
}

extension MapRouter: MapRouterInput {
    func showClusterPosts(data: [PostData4Map]) {
        let container = GeopointPlacesContainer.assemble(with: GeopointPlacesContext(posts: data))
        viewController?.navigationController?.pushViewController(container.viewController, animated: true)
    }
    
    func showPost(context: PostContextWithoutAvatar) {
        print("\(#function) = \(context)")
        let onePostViewController: PostViewController = PostViewController()
        onePostViewController.setup(context: context)
        viewController?.navigationController?.pushViewController(onePostViewController, animated: true)
    }
}
