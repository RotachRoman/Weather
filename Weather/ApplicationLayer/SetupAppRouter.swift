//
//  SetupAppRouter.swift
//  Weather
//
//  Created by Rotach Roman on 06.10.2023.
//

import UIKit

protocol SetupAppRouterType {
    init(window: UIWindow?)
    func getAppRouter() -> AppRouterType?
}

final class SetupAppRouter: SetupAppRouterType{
    private var window: UIWindow?
    private var appRouter: AppRouterType?
    
    required init(window: UIWindow?){
        self.window = window
        setup()
    }
    
    func getAppRouter() -> AppRouterType? {
        return appRouter
    }
    
    private func setup() {
        let viewController = setupViewController()
        self.appRouter = AppRouter(appViewController: viewController)
        self.appRouter?.startApplication()
    }
    
    private func setupViewController() -> AppViewControllerType {
        let viewController = AppViewController(nibName: nil, bundle: nil)
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
        return viewController
    }
}
