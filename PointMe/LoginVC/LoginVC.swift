
import UIKit

enum Constants {
    static let defaultBackgroundColor: UIColor  = .init(red: 229 / 255, green: 229 / 255, blue: 229 / 255, alpha: 100)
}

class LoginVC: UIViewController {
    
    private let loginButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.defaultBackgroundColor
        
        setupButton(button: loginButton, title: "Log in")
    }
    private func setupButton(button: UIButton, title: String) {
        view.addSubview(button)
        button.frame = CGRect(x: 25, y: 380, width: UIScreen.main.bounds.width - 50, height: 100)
        button.backgroundColor = .black
        button.layer.cornerRadius = 4
        button.tintColor = .white
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(SetupTabBar), for: .touchUpInside)
    }
    
@objc
private func SetupTabBar() {
    
    let tabBarVC = UITabBarController()
    let vc1 = UINavigationController(rootViewController: FeedNewsVC())
    let vc2 = UINavigationController(rootViewController: FindVC())
    let vc3 = UINavigationController(rootViewController: MapVC())
    let vc4 = UINavigationController(rootViewController: FavoritesVC())
    let vc5 = UINavigationController(rootViewController: AccountVC())
    
    let images = ["newspaper", "magnifyingglass", "map", "star", "person"]
    let titles = ["Новости", "Поиск", "Карта", "Избранные", "Аккаунт"]
    

    vc1.title = titles[0]
    vc2.title = titles[1]
    vc3.title = titles[2]
    vc4.title = titles[3]
    vc5.title = titles[4]
        
    tabBarVC.setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        
    guard let items = tabBarVC.tabBar.items else {
        return
    }
        
    for i in 0..<items.count {
        items[i].image = UIImage(systemName: images[i])
        items[i].selectedImage = UIImage(systemName: images[i] + ".fill")
    }
        
    tabBarVC.tabBar.layoutMargins.top = 10
    tabBarVC.tabBar.tintColor = .black
        
    tabBarVC.modalPresentationStyle = .fullScreen
    
    tabBarVC.tabBar.layer.shadowColor = UIColor.darkGray.cgColor
    tabBarVC.tabBar.layer.shadowOpacity = 1
    tabBarVC.tabBar.layer.shadowOffset = .zero
    tabBarVC.tabBar.layer.shadowRadius = 2
    
    present(tabBarVC, animated: false)
    }
    
}
