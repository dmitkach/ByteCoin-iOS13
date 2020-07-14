//
//  RateModel.swift
//  ByteCoin
//
//  Created by Dmitry Tkach on 14.07.2020.
//  Copyright © 2020 Dmitry Tkach. All rights reserved.
//

import Foundation

struct RateModel {
    let fromCurrency: String
    let toCurrency: String
    let rate: Double
    
    func getRateString() -> String {
        return String(format: "%.2f", rate)
    }
    
    func getSourceCurrencyString() -> String {
        return fromCurrency
    }
    
    func getTargetCurrencyString() -> String {
        return toCurrency
    }
}
