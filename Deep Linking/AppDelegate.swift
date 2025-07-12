import UIKit

/// 1. Implementing Deep Linking with Custom URL Schemes
///  This is the simplest method for deep linking.
///
/// Step 1: Configure URL Scheme
///  1. Open your Xcode project.
///  2. Go to Project Settings > Info > URL Types.
///  3. Click + and add:
///  4. Identifier: com.yourapp.scheme
///  5. URL Schemes: myapp (or any unique scheme)
/// Step 2: Handle Deep Links in AppDelegate
///  Modify AppDelegate.swift to handle incoming deep links.
                                    
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//
//    /// Initializes the app with a UINavigationController containing the initial view controller.
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        
//        // Initialize the window
//        window = UIWindow(frame: UIScreen.main.bounds)
//        
//        // Set the rootViewController with NavigationController
//        let homeVC = HomeViewController() // Replace with your actual Home VC
//        let navController = UINavigationController(rootViewController: homeVC)
//        
//        window?.rootViewController = navController
//        window?.makeKeyAndVisible()
//        
//        return true
//    }

    // Handle custom URL scheme deep linking 

//    func application(
//        _ app: UIApplication,
//        open url: URL,
//        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//    ) -> Bool {
//        print("Deep Link Opened: \(url.absoluteString)") // Debugging
//        
//        if url.scheme == "quorellc" {
//            handleDeepLink(url)
//            return true
//        }
//        return false
//    }
//    
//    private func handleDeepLink(_ url: URL) {
//        guard let host = url.host else { return }
//        
//        let navController = window?.rootViewController as? UINavigationController
//        
//        switch host {
//        case "profile":
//            let profileVC = ProfileViewController()
//            navController?.pushViewController(profileVC, animated: true)
//        case "settings":
//            let settingsVC = SettingsViewController()
//            navController?.pushViewController(settingsVC, animated: true)
//        default:
//            break
//        }
//    }
//}

// MARK: - Test Deep Linking
/// 1. Open the iOS Simulator.
/// 2. Run the following command in Terminal:
/// xcrun simctl openurl booted quorellc://profile

// MARK: - Test Universal Links
/// 2. Universal Link:
/// Click https://yourdomain.com/profile from an email or Safari on a real device.


// AppDelegate.swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController(rootViewController: HomeViewController())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        
        return true
    }
    
    // Handle URL Scheme Deep Linking (myapp://profile)
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return DeepLinkManager.handle(url: url)
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else {
            return false
        }

        print("🔗 Universal Link Opened: \(url.absoluteString)")
        return DeepLinkManager.handle(url: url)
    }
}
