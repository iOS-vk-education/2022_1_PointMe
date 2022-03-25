import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let debugMode: Bool = false
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toNextScreen(notification:)),
            name: LoginViewController.NotificationDone,
            object: nil
        )
        
        let authNavigationController: AuthNavigationController = AuthNavigationController(rootViewController: LoginViewController())

        let initViewController = debugMode ? TabBarController() : authNavigationController
        
        window?.rootViewController = initViewController
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    
    func sceneDidBecomeActive(_ scene: UIScene) {}

    
    func sceneWillResignActive(_ scene: UIScene) {}

    
    func sceneWillEnterForeground(_ scene: UIScene) {}

    
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    
    @objc func toNextScreen(notification: Notification) {
        let initViewController = TabBarController()
        self.window?.rootViewController = initViewController
    }
}

