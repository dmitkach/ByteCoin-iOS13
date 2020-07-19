//
//  ViewController.swift
//  ByteCoin
//
//  Created by Dmitry Tkach on 28.06.2020.
//  Copyright © 2020 Dmitry Tkach. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var sourceCurrencyLabel: UILabel!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var sourceValueLabel: UILabel!
    @IBOutlet weak var targetValueLabel: UILabel!
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        coinManager.delegate = self
        
        currencyPickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView(currencyPickerView, didSelectRow: 0, inComponent: 0)
    }
}

//MARK: - UIPickerViewDelegate

extension MainViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sourceCurrency = coinManager.currencyArray[0][pickerView.selectedRow(inComponent: 0)]
        let targetCurrency = coinManager.currencyArray[1][pickerView.selectedRow(inComponent: 1)]
        
        coinManager.fetchCoinRate(from: sourceCurrency, to: targetCurrency)
    }
}

//MARK: - UIPickerDataSource

extension MainViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray[component].count
    }
}
//MARK: - BitCoinManagerDelegate

extension MainViewController: CoinManagerDelegate {
    func didUpdateCurrency(rateModel: RateModel) {
        DispatchQueue.main.async {
            self.sourceCurrencyLabel.text = rateModel.getSourceCurrencyString()
            self.targetValueLabel.text = rateModel.getRateString()
            self.targetCurrencyLabel.text = rateModel.getTargetCurrencyString()
        }
    }
    
    func didFailWithError(_ errorString: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
