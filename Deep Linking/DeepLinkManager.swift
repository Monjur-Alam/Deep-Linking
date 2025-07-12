//
//  DeepLinkManager.swift
//  Deep Linking
//
//  Created by MunjurAlam on 29/6/25.
//

// DeepLinkManager.swift
import UIKit

class DeepLinkManager {
    static func handle(url: URL) -> Bool {
        let urlString = url.absoluteString.lowercased()

        if urlString.contains("/profile") {
            navigate(to: ProfileViewController())
        } else if urlString.contains("/settings") {
            navigate(to: SettingsViewController())
        } else {
            return false
        }
        return true
    }

    private static func navigate(to viewController: UIViewController) {
        guard let window = UIApplication.shared.windows.first,
              let navController = window.rootViewController as? UINavigationController else {
            return
        }
        navController.pushViewController(viewController, animated: true)
    }
}
