//
//  ViewController.swift
//  ByteCoin
//
//  Created by Dmitry Tkach on 28.06.2020.
//  Copyright © 2020 Dmitry Tkach. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinValueLabel: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    var bitCoinManager = CoinManager()
    
    override func viewDidLoad() {
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        bitCoinManager.delegate = self
        
        super.viewDidLoad()
    }


}

//MARK: - UIPickerViewDelegate

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bitCoinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = bitCoinManager.currencyArray[row]
        bitCoinManager.fetchCoinRate(from: selectedCurrency)
    }
}

//MARK: - UIPickerDataSource

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bitCoinManager.currencyArray.count
    }
    
    
}
//MARK: - BitCoinManagerDelegate

extension MainViewController: BitCoinManagerDelegate {
    func didUpdateCurrency(rateModel: RateModel) {
        DispatchQueue.main.async {
            self.bitcoinValueLabel.text = rateModel.getRateString()
            self.currencyLabel.text = rateModel.getSourceCurrencyString()
        }
    }
    
    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
}
