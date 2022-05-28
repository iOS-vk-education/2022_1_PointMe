//
//  GeopointPlacesRouter.swift
//  PointMe
//
//  Created by Павел Топорков on 28.05.2022.
//  
//

import UIKit

final class GeopointPlacesRouter {
    var viewController: UIViewController?
}

extension GeopointPlacesRouter: GeopointPlacesRouterInput {
    func showPost(context: PostContextWithoutAvatar) {
        let onePostViewController: PostViewController = PostViewController()
        onePostViewController.setup(context: context)
        viewController?.navigationController?.pushViewController(onePostViewController, animated: true)
    }
}
