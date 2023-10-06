//
//  AppRouter.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import Foundation

protocol AppRouterType {
    func startApplication()
}

final class AppRouter {
    private let appViewController: AppViewControllerType
    
    private var weatherWireframe: WeatherWireframe?
    
    init(appViewController: AppViewControllerType) {
        self.appViewController = appViewController
    }
    
    private func routeToView() {
        self.weatherWireframe = WeatherWireframe(appViewController: self.appViewController)
        self.weatherWireframe?.startModule()
    }
}

extension AppRouter: AppRouterType {
    func startApplication() {
        self.routeToView()
    }
}


