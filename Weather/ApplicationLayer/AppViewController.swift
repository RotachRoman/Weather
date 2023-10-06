//
//  AppViewController.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import UIKit

protocol AppViewControllerType: AnyObject {
    func updateCurrent(to viewController: UIViewController)
}

class AppViewController: ViewController {
    private var current: UIViewController?
}

extension AppViewController: AppViewControllerType {
    func updateCurrent(to viewController: UIViewController) {
        self.addChild(viewController)
        viewController.view.frame = self.view.bounds
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        self.current?.willMove(toParent: nil)
        self.current?.view.removeFromSuperview()
        self.current?.removeFromParent()
        self.current = viewController
    }
}
