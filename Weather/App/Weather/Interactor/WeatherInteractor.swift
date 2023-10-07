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
        //когда мы загружаем при первом запуске выполняется
        case loadData
        //когда мы загружаем при поиске
        case search
        //Когда выбрали один из найденых городов
        case chooseSearchedCity
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
    
    func chooseSearchCity(_ index: Int) {
        //Нужно передавать для дальнейшей реализации вытягивания городов с запроса
        guard let searchWeatherResponse = searchWeatherResponse else {
            return
        }
        UserDefaultsManager.choosenCity = searchWeatherResponse.name
        
        let lat = String(searchWeatherResponse.coord.lat)
        let lon = String(searchWeatherResponse.coord.lon)
        
        fetchDailyWeather(
            city: searchWeatherResponse.name,
            lat: lat,
            lon: lon)
    }
}

//MARK: - Network -
extension WeatherInteractor {
    func fetchWeatherInfo(city: String) {
        WeatherService().fetchWeather(city: city) {[weak self] response in
            if let response = response {
                
                switch self?.stateLoad {
                case .loadData: self?.successLoadfetchWeatherInfo(response)
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
                self?.sucessFetchDaily(response)
                
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
    
    private func sucessFetchDaily(_ response: DailyWeatherResponse){
        objects = []
        guard let infoResponse = stateLoad == .search ? searchWeatherResponse : infoWeatherResponse else {
            return
        }
        DispatchQueue.main.async {[weak self] in
            self?.interatorDelegate?.createObject(
                infoResponse: infoResponse,
                dailyResponse: response)
        }
    }
}
