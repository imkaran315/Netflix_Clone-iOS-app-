//
//  ViewController.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 14/02/24.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = HomeVC()
        let vc2 = UpcomingVC()
        let vc3 = SearchVC()
        let vc4 = LibraryVC()
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
        
        ///sets the title and icons of the tab bars
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "play.circle"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "arrow.down.to.line"), tag: 1)
        
        ///changes tint of tabbar label to label colour instead of blue
         tabBar.tintColor = .label
        
        /// pushes these vcs on display
        setViewControllers([nav1,nav3,nav2,nav4], animated: false)
    }


}

