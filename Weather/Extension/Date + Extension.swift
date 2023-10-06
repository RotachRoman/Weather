//
//  Date + Extension.swift
//  Weather
//
//  Created by Rotach Roman on 06.10.2023.
//

import Foundation

extension Date {
    var simpleDateStringRepresentationWithoutYear : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: self)
    }
}
