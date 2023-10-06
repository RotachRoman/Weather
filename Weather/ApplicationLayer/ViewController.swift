//
//  ViewController.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    lazy var loaderView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .darkGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        return indicator
    }()
    
    private var isLoaderStopped = true
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.addSubviews()
        self.addStyle()
        self.addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.checkInternetConnection()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.stopLoader()
    }
    
    //MARK: Loader
    public func startLoader(with title: String = "", message: String? = nil) {
        isLoaderStopped = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if !self.isLoaderStopped {
                self.loaderView.isHidden = false
                self.loaderView.startAnimating()
            }
        }
    }
    
    public func stopLoader() {
        loaderView.stopAnimating()
        isLoaderStopped = true
    }
    
    //MARK: Setup
    open func addSubviews() {}
    
    open func addStyle() {}
    
    open func addConstraints() {}
}

//MARK: Check Connetion
extension ViewController {
    func checkInternetConnection() {
        if !(NetworkMonitor.shared.isConnected) {
            navigateToNoInternetConnection()
        }
    }
    
    func navigateToNoInternetConnection() {
        let alertController = UIAlertController(
            title: "Потеряно соединение",
            message: "Соединение с сервером потеряно. Пожалуйста, проверьте свое интернет-соединение и повторите попытку.",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) {[weak self] _ in
            self?.checkInternetConnection()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
