import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let isAuth: Bool = DatabaseManager.shared.currentUserUID != nil ? true : false
        if isAuth {
            print("[DEBUG]: user is auth")
        }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        let navigationController: AuthNavigationController = AuthNavigationController(
            rootViewController: SignInViewController()
        )
        
        let initViewController = isAuth ? TabBarController() : navigationController
        
        window?.rootViewController = initViewController
        window?.makeKeyAndVisible()
        
    }

    
    func sceneDidDisconnect(_ scene: UIScene) {}

    
    func sceneDidBecomeActive(_ scene: UIScene) {}

    
    func sceneWillResignActive(_ scene: UIScene) {}

    
    func sceneWillEnterForeground(_ scene: UIScene) {}

    
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

