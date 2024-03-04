import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = setupNavigationController()
        window?.makeKeyAndVisible()
        return true
    }
    
    private func setupNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.viewControllers.append(ViewController())
        return navigationController
    }
}
