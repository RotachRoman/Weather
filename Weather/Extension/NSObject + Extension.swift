//
//  NSObject + Extension.swift
//  Weather
//
//  Created by Rotach Roman on 07.10.2023.
//

import Foundation

extension NSObject {
    func delayDataEntry(text: String, action: Selector, afterDelay: Double = 0.5) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(action, with: text, afterDelay: afterDelay)
    }
}
