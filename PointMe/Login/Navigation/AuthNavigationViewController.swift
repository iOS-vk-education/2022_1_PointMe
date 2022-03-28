import UIKit


final class AuthNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.titleNavBar
        ]
        self.navigationBar.standardAppearance = appearance
        
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationBar.layer.shadowOpacity = 1
        self.navigationBar.layer.shadowOffset = .zero
        self.navigationBar.layer.shadowRadius = 2
        
        self.navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        self.navigationBar.tintColor = .navBarItemColor
    }
}
