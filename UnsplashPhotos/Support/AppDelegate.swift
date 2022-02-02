//
//  AppDelegate.swift
//  UnsplashPhotos
//
//  Created by Vladimir Oleinikov on 01.02.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init()
        window?.rootViewController = PhotosTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

