import UIKit


final class AuthNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    
    private func setupNavigationBar() {
        // setup default config for view navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.titleNavBar
        ]
        self.navigationBar.standardAppearance = appearance
        
        // setup shadow
        self.navigationBar.layer.masksToBounds = false
        self.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationBar.layer.shadowOpacity = 1
        self.navigationBar.layer.shadowOffset = .zero
        self.navigationBar.layer.shadowRadius = 2
        
        // setup color for navigation bar items
        self.navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        self.navigationBar.tintColor = .navBarItemColor
    }
    
    
}
