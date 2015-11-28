//
//  AppDelegate.swift
//  reactive-recipe-2
//
//  Created by krawiecp on 28/11/2015.
//  Copyright © 2015 Pawel Krawiec. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        CoreDataStack.defaultStack.loadFirstTimeData()

        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            let mainViewModel = MainViewModel(coreDataStack: CoreDataStack.defaultStack)
            let mainViewController = MainViewController(viewModel: mainViewModel)
            let navigationController = UINavigationController(rootViewController: mainViewController)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        
        return true
    }
}

