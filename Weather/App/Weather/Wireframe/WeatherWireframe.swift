//
//  WeatherWireframe.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import UIKit

final class WeatherWireframe: BaseWireframe {
    
    private weak var appViewController: AppViewControllerType?
    
    init(appViewController: AppViewControllerType){
        self.appViewController = appViewController
    }
}

// MARK: - Extensions -

extension WeatherWireframe: WeatherWireframeInterface {
    func startModule() {
        let weatherViewController = WeatherViewController()

        let interactor = WeatherInteractor()
        let presenter = WeatherPresenter(view: weatherViewController, interactor: interactor, wireframe: self)
        
        interactor.interatorDelegate = presenter
        weatherViewController.presenter = presenter
        
        let navigationViewController = UINavigationController(rootViewController: weatherViewController)
        self.appViewController?.updateCurrent(to: navigationViewController)
    }
}
