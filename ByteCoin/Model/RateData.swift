//
//  RateData.swift
//  ByteCoin
//
//  Created by Dmitry Tkach on 14.07.2020.
//  Copyright © 2020 Dmitry Tkach. All rights reserved.
//

import Foundation

struct RateData: Codable {
    let error: String?
    let time: String?
    let assetIdBase: String?
    let assetIdQuote: String?
    let rate: Double?
    
    private enum CodingKeys: String, CodingKey {
        case error
        case time
        case assetIdBase = "asset_id_base"
        case assetIdQuote = "asset_id_quote"
        case rate
    }
}
