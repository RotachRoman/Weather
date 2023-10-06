//
//  WeatherService.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import Foundation

protocol WeatherServiceType {
    func fetchWeather(city: String, completion: @escaping (WeatherInfoResponse?) -> ())
}

final class WeatherService: WeatherServiceType {
    //MARK: Properties
    private let apiKey = "8d2fce78ffd699b92cb0a982f5b9bbbf"
    private let url = "http://api.openweathermap.org/data/2.5/"
    private let dateMinuteInterval = 10 * 60
    
    private var cashedWeather: [String: WeatherInfoResponse] = [:]
    private var cashedWeatherDaly: [String: DailyWeatherResponse] = [:]

    var dataFetcher: DataFetcherProtocol!
    
    init(dataFetcher: DataFetcherProtocol = DataFetcher(getDataService: NetworkService())){
        self.dataFetcher = dataFetcher
    }
    
    //MARK: Загрзука погоды по имени города
    func fetchWeather(city: String, completion: @escaping (WeatherInfoResponse?) -> ()){
        //проверяем, если уже искали этот город в течении предыдущих 10 минут, то будем брать значение из кеша запросов
        if let weather = cashedWeather[city], let start =  weather.dateSendResponse,
           DateInterval(start: start, duration: TimeInterval(dateMinuteInterval)).contains(Date()) {
            
            completion(weather)
            return
            
        } else {
            let urlString = url + "weather?q=\(city)&appid=\(apiKey)"
            dataFetcher.dataFetcher(urlString: urlString) {[weak self] (response: WeatherInfoResponse?) in
                self?.cashedWeather[city] = response
                completion(response)
            }
        }
    }
    
    //MARK: Загрузка погоды на след дни
    func fetchDalyWeather(city: String, lon: String, lat: String, completion: @escaping (DailyWeatherResponse?) -> ()){
        //проверяем, если уже искали погоду для этого города, то будем брать значение из кеша запросов
        if let weather = cashedWeatherDaly[city] {
            completion(weather)
            return
        } else {
            let urlString = url + "onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=\(apiKey)"
            dataFetcher.dataFetcher(urlString: urlString) {[weak self] (response: DailyWeatherResponse?) in
                self?.cashedWeatherDaly[city] = response
                completion(response)
            }
        }
    }
}
