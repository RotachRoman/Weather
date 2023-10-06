//
//  WeatherEntity.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import Foundation

struct WeatherEntity {
    struct DailyListCell: CellObject {
        var date: String
        var temp: String
    }
    
    struct Info: CellObject {
        var city: String
        var temp: String
        var humidity: String
        var wind: String
    }
    
    struct CityList: CellObject {
        var city: String
        var temp: String
    }
}
