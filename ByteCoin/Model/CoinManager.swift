//
//  BitCoinManager.swift
//  ByteCoin
//
//  Created by Dmitry Tkach on 28.06.2020.
//  Copyright © 2020 Dmitry Tkach. All rights reserved.
//

import Foundation

protocol BitCoinManagerDelegate {
    func didUpdateCurrency(rateModel: RateModel)
    func didFailWithError(_ errorString: String)
}

struct CoinManager {
    
    private let bitCoinURL = "https://rest.coinapi.io/v1/exchangerate/"
    private let apiKey = "A134C4A4-D8A5-43C9-875C-33F9F8A78460"
    let currencyArray =
        ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS",
         "INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK",
         "SGD","USD","ZAR"]
    var delegate: BitCoinManagerDelegate?
    
    func fetchCoinRate(from fromCurrency: String) {
        let urlString = "\(bitCoinURL)BTC/\(fromCurrency)?apikey=\(apiKey)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if let safeError = error {
                    self.delegate?.didFailWithError(safeError.localizedDescription)
                    return
                }
                if let safeData = data {
                    if let currencyRate = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCurrency(rateModel: currencyRate)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ rateData: Data) -> RateModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(RateData.self, from: rateData)
            if let error = decodedData.error {
                delegate?.didFailWithError(error)
                return nil
            }
            let sourceCurrency = decodedData.assetIdQuote!
            let targetCurrency = decodedData.assetIdBase!
            let currencyRate = decodedData.rate!
            return RateModel(fromCurrency: sourceCurrency, toCurrency: targetCurrency, rate: currencyRate)
        } catch {
            delegate?.didFailWithError(error.localizedDescription)
            return nil
        }
    }
    
}
