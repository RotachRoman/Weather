//
//  WeatherPresenter + CreateObj.swift
//  Weather
//
//  Created by Rotach Roman on 06.10.2023.
//

import Foundation

extension WeatherPresenter {
    func createInfoCell(weather: WeatherInfoResponse) -> CellObject {
        return WeatherEntity.Info(
            city: weather.name,
            temp: (weather.main.temp - 273).formattedWithSeparator + "°",
            humidity: "Давление - " + String(weather.main.humidity) + " мм рт. ст.",
            wind: "Ветер - " + weather.wind.speed.formattedWithSeparator + " м/c")
    }
    
    func createDailyWeather(_ dailyResponse: DailyWeatherResponse) -> [CellObject] {
        var weatherObj: [WeatherEntity.DailyListCell] = []
        
        dailyResponse.daily.forEach {
            if weatherObj.count == 7 {
                return 
            }
            let date = Date(timeIntervalSince1970: TimeInterval($0.dt))
            
            weatherObj.append(.init(
                date: date.simpleDateStringRepresentationWithoutYear,
                temp: ($0.temp.day - 273).formattedWithSeparator + "°"))
        }
        
        return weatherObj
    }
}
