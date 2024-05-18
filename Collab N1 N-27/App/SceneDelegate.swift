//
//  SceneDelegate.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers =  [AirQualityVC(), WeatherPageVC(), SpeciePageVC(), SolarResourcePageVC(), PopulationPageVC()]
        
        tabBarController.tabBar.items?[0].image = UIImage(systemName: "air.conditioner.vertical.fill")
        tabBarController.tabBar.items?[1].image = UIImage(systemName: "sun.min.fill")
        tabBarController.tabBar.items?[2].image = UIImage(systemName: "aspectratio.fill")
        tabBarController.tabBar.items?[3].image = UIImage(systemName: "bolt.circle.fill")
        tabBarController.tabBar.items?[4].image = UIImage(systemName: "figure.and.child.holdinghands")
        
        tabBarController.tabBar.tintColor = .systemBlue
        tabBarController.tabBar.backgroundColor = .backGroundColoring
        tabBarController.tabBar.unselectedItemTintColor = UIColor.lightGray
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
    }
    
}
