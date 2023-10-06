//
//  WeatherPresenter.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import Foundation

final class WeatherPresenter {

    // MARK: - Private properties -

    private unowned let view: WeatherViewInterface
    private let interactor: WeatherInteractorInterface&WeatherInteractorSearchInterface
    private let wireframe: WeatherWireframeInterface

    // MARK: - Init
    init(view: WeatherViewInterface, interactor: WeatherInteractorInterface&WeatherInteractorSearchInterface, wireframe: WeatherWireframeInterface) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        interactor.fetchWeather(city: nil)
    }
}

// MARK: - Extensions -

//MARK: WeatherPresenterInterface
extension WeatherPresenter: WeatherPresenterInterface {
    func tableCellObj(row: Int, section: Int) -> CellObject {
        return interactor.objects[row]
    }
    
    func countTableObjects() -> Int {
        return interactor.objects.count
    }
}

//MARK: FindWeatherPresenterInterface
extension WeatherPresenter: FindWeatherPresenterInterface {
    func searchTableCellObj(row: Int, section: Int) -> CellObject {
        return interactor.searchObj[row]
    }
    
    func searchCountTableObjects() -> Int {
        return interactor.searchObj.count
    }
    
    func searchCityWheater(city: String) {
        interactor.search(city: city)
    }
}

extension WeatherPresenter: WeatherInteractorDelegate {
    func createObject(infoResponse: WeatherInfoResponse, dailyResponse: DailyWeatherResponse) {
        interactor.objects = [createInfoCell(weather: infoResponse)]
        interactor.objects.append(contentsOf: createDailyWeather(dailyResponse))
        view.reloadView()
    }
    
    func showError(_ message: String) {
        //Провести во вью вывод ошибки(по тз нет необходимости)
    }
    
    func successSearch(infoResponse: WeatherInfoResponse){
        interactor.searchObj = []
        interactor.searchObj.append(WeatherEntity.CityList(
            city: infoResponse.name,
            temp: (infoResponse.main.temp - 273).formattedWithSeparator + "°"))
        view.reloadSearch()
    }
}
