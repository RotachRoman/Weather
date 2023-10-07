//
//  WeatherInterfaces.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import UIKit

//MARK: - Router
protocol BaseWireframe: AnyObject {
}

protocol WeatherWireframeInterface: AnyObject {
    func startModule()
}

//MARK: - View
protocol WeatherViewInterface: AnyObject {
    func reloadView()
    func reloadSearch()
}

//MARK: - Presenter
protocol WeatherPresenterInterface: AnyObject {
    func viewDidLoad()
    func countTableObjects() -> Int
    func tableCellObj(row: Int, section: Int) -> CellObject
    
}

protocol FindWeatherPresenterInterface: AnyObject {
    func searchCountTableObjects() -> Int
    func searchTableCellObj(row: Int, section: Int) -> CellObject
    func searchCityWheater(city: String)
    func chooseSearchCity(_ index: Int)
}

//MARK: - Interactor
protocol WeatherInteractorInterface: AnyObject {
    var objects: [CellObject] { get set }
    func fetchWeather(city: String?)
}

protocol WeatherInteractorSearchInterface: AnyObject {
    var searchObj: [CellObject] { get set }
    func search(city: String)
    func chooseSearchCity(_ index: Int) 
}

protocol WeatherInteractorDelegate: AnyObject {
    func createObject(infoResponse: WeatherInfoResponse, dailyResponse: DailyWeatherResponse)
    func successSearch(infoResponse: WeatherInfoResponse)
    func showError(_ message: String)
}
