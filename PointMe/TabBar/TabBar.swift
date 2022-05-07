import UIKit

final class TabBarController: UITabBarController {
    
    private let vc1 = UINavigationController(rootViewController: FeedNewsViewController())
    private let vc2 = UINavigationController(rootViewController: FindViewController())
    private let vc3 = UINavigationController(rootViewController: MapViewController())
    private let vc4 = UINavigationController(rootViewController: FavoritesViewController())
    private var vc5 = UINavigationController(rootViewController: MyAccountViewController())
    
    private let images = ["newspaper", "magnifyingglass", "map", "star", "person"]
    private let titles = ["Новости", "Поиск", "Карта", "Избранные", "Аккаунт"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        let builder = MyAccountBuilder()
        let viewController = builder.build()
        vc5 = UINavigationController(rootViewController: viewController)
        
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
        tabBar.unselectedItemTintColor = .black
        modalPresentationStyle = .fullScreen
        
        setupShadow()
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            let tabBarItemAppearance = UITabBarItemAppearance()

            tabBarItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
            tabBarItemAppearance.normal.iconColor = .black
            tabBarItemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.black]
            tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
            tabBarAppearance.backgroundEffect = UIBlurEffect(style: .light)
            
            tabBar.standardAppearance = tabBarAppearance
//            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    private func setupShadow()
    {
        tabBar.layer.shadowColor = UIColor.darkGray.cgColor
        UITabBar.appearance().standardAppearance.backgroundColor = UIColor.darkGray
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 2
    }
}
