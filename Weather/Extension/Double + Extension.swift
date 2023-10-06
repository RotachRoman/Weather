//
//  Double + Extension.swift
//  Weather
//
//  Created by Rotach Roman on 06.10.2023.
//

import Foundation

extension Double {
    var formattedWithSeparator: String {
        guard let newValue = Formatter.withSeparator.string(for: self) else {
            return ""
        }
        
        let formattedValue = String(format: "%.1f", Double(newValue) ?? 0.0)
        
        return formattedValue.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
    }
}
