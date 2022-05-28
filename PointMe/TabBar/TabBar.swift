import UIKit

final class TabBarController: UITabBarController {
    
    private let images = ["newspaper", "magnifyingglass", "map", "star", "person"]
    private let titles = ["Новости", "Поиск", "Карта", "Избранные", "Аккаунт"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        let builder = MyAccountBuilder()
        let viewController = builder.build()
        
        let mapContainer: MapContainer = MapContainer.assemble(with: MapContext())
        
        let vc1 = UINavigationController(rootViewController: FeedNewsViewController())
        let vc2 = UINavigationController(rootViewController: FindViewController())
        let vc3 = UINavigationController(rootViewController: mapContainer.viewController)
        let vc4 = UINavigationController(rootViewController: FavoritesViewController())
        let vc5 = UINavigationController(rootViewController: viewController)
        
        vc1.tabBarItem.title = titles[0]
        vc2.tabBarItem.title = titles[1]
        vc3.tabBarItem.title = titles[2]
        vc4.tabBarItem.title = titles[3]
        vc5.tabBarItem.title = titles[4]
        
        setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        
        guard let items = tabBar.items else {
            return
        }
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: images[i])
            if (i != 1) {
                items[i].selectedImage = UIImage(systemName: images[i] + ".fill")
            } else {
                items[i].selectedImage = UIImage(systemName: images[i], withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            }
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
