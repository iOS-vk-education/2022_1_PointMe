import UIKit

final class TabBarController: UITabBarController {
    
    private let vc1 = UINavigationController(rootViewController: FeedNewsViewController())
    private let vc2 = UINavigationController(rootViewController: FindViewController())
    private let vc3 = UINavigationController(rootViewController: MapViewController())
    private let vc4 = UINavigationController(rootViewController: FavoritesViewController())
    private let vc5 = UINavigationController(rootViewController: AccountViewController())
    
    private let images = ["newspaper", "magnifyingglass", "map", "star", "person"]
    private let titles = ["Новости", "Поиск", "Карта", "Избранные", "Аккаунт"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        vc1.title = titles[0]
        vc2.title = titles[1]
        vc3.title = titles[2]
        vc4.title = titles[3]
        vc5.title = titles[4]
        
        setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        
        guard let items = tabBar.items else {
            return
        }
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
            items[i].selectedImage = UIImage(systemName: images[i] + ".fill")
        }
        
        tabBar.tintColor = .black
        modalPresentationStyle = .fullScreen
        
        setupShadow()
    }
    
    private func setupShadow()
    {
        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 2
    }
}
