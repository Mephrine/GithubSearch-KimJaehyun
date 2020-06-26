//
//  AppDelegate.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//
import UIKit
import RxFlow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var coordinator = FlowCoordinator()
    lazy var services: AppServices = {
        let mainService = MainService()
        return AppServices(mainService: mainService)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        // flow 생성 및 코디네이터에 적용
        let appFlow = AppFlow(service: services)
        Flows.whenReady(flow1: appFlow) { [unowned self] root in
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController = root
        }
        
        self.coordinator.coordinate(flow: appFlow, with: AppStepper(withService: services))
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

