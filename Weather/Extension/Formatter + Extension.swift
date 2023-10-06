//
//  Formatter + Extension.swift
//  Weather
//
//  Created by Rotach Roman on 06.10.2023.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
