//
//  WeatherEntity.swift
//  Weather
//
//  Created by Rotach Roman on 05.10.2023.
//

import Foundation

struct WeatherEntity {
    //MARK: DailyListCell
    struct DailyListCell: CellObject {
        var date: String
        var temp: String
    }
    
    //MARK: Info
    struct Info: CellObject {
        var city: String
        var temp: String
        var humidity: String
        var wind: String
    }
    
    //MARK: CityList
    struct CityList: CellObject {
        var city: String
        var temp: String
    }
}
