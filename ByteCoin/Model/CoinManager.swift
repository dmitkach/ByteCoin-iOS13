//
//  BitCoinManager.swift
//  ByteCoin
//
//  Created by Dmitry Tkach on 28.06.2020.
//  Copyright © 2020 Dmitry Tkach. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(rateModel: RateModel)
    func didFailWithError(_ errorString: String)
}

struct CoinManager {
    
    private let coinURL = "https://rest.coinapi.io/v1/exchangerate/"
    private let apiKey = "A134C4A4-D8A5-43C9-875C-33F9F8A78460"
    let currencyArray =
        [
            ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS",
             "INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK",
             "SGD","USD","ZAR"],
            ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS",
             "INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK",
             "SGD","USD","ZAR"]
    ]
    var delegate: CoinManagerDelegate?
    
    func fetchCoinRate(from fromCurrency: String, to toCurrency: String) {
        let urlString = "\(coinURL)\(fromCurrency)/\(toCurrency)?apikey=\(apiKey)"
        
        if fromCurrency == toCurrency {
            self.delegate?.didUpdateCurrency(rateModel:
                RateModel(fromCurrency: fromCurrency, toCurrency: toCurrency, rate: 1.0))
        } else {
            performRequest(with: urlString)
        }
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.delegate?.didFailWithError(error.localizedDescription)
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
            let targetCurrency = decodedData.assetIdQuote!
            let sourceCurrency = decodedData.assetIdBase!
            let currencyRate = decodedData.rate!
            return RateModel(fromCurrency: sourceCurrency, toCurrency: targetCurrency, rate: currencyRate)
        } catch {
            delegate?.didFailWithError(error.localizedDescription)
            return nil
        }
    }
    
}
