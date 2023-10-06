//
//  WeatherInteractor.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import Foundation

final class WeatherInteractor {
    //MARK: Properties
    weak var interatorDelegate: WeatherInteractorDelegate?
    
    var objects: [CellObject] = []
    var searchObj: [CellObject] = []
    
    private var stateLoad: StateFetch = .loadData
    
    var infoWeatherResponse: WeatherInfoResponse?
    var searchWeatherResponse: WeatherInfoResponse?
    
    enum StateFetch {
        case loadData
        case search
    }
}

// MARK: - Extensions -

extension WeatherInteractor: WeatherInteractorInterface {
    func fetchWeather(city: String?){
        stateLoad = .loadData
        fetchWeatherInfo(city: city ?? UserDefaultsManager.choosenCity ?? "Moscow")
    }
    
}

//MARK: WeatherInteractorSearchInterface
extension WeatherInteractor: WeatherInteractorSearchInterface {
    func search(city: String) {
        stateLoad = .search
        fetchWeatherInfo(city: city)
    }
}

//MARK: - Network -
extension WeatherInteractor {
    func fetchWeatherInfo(city: String) {
        WeatherService().fetchWeather(city: city) {[weak self] response in
            if let response = response {
                switch self?.stateLoad {
                    //когда мы загружаем при первом запуске выполняется
                case .loadData: self?.successLoadfetchWeatherInfo(response)
                    //когда мы загружаем при поиске
                case .search: self?.successSearch(response)
                default: break
                }
               
            } else {
                self?.interatorDelegate?.showError("Ошибка загрузки")
            }
        }
    }
    
    func fetchDailyWeather(city: String, lat: String, lon: String) {
        WeatherService().fetchDalyWeather(city: city, lon: lon, lat: lat) {[weak self] response in
            if let response = response {
                
                guard let infoWeatherResponse = self?.infoWeatherResponse else { return }
                
                self?.objects = []
                
                DispatchQueue.main.async {
                    self?.interatorDelegate?.createObject(
                        infoResponse: infoWeatherResponse,
                        dailyResponse: response)
                }
                
            } else {
                self?.interatorDelegate?.showError("Ошибка загрузки")
            }
        }
    }
    
    //Success
    private func successLoadfetchWeatherInfo(_ response: WeatherInfoResponse) {
        infoWeatherResponse = response
        
        let lat = String(response.coord.lat)
        let lon = String(response.coord.lon)
        
        UserDefaultsManager.choosenCity = response.name
        fetchDailyWeather(city: response.name, lat: lat, lon: lon)
    }
    
    private func successSearch(_ response: WeatherInfoResponse) {
        searchWeatherResponse = response
        DispatchQueue.main.async {[weak self] in
            self?.interatorDelegate?.successSearch(infoResponse: response)
        }
    }
}
