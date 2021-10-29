import UIKit

class ViewController: UIViewController  {


    @IBOutlet weak var bitcoinLabel: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyRate: UILabel!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        // Do any additional setup after loading the view.
    }


}

//MARK: - delegate extensions

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currency)
    }
    
}

extension ViewController : CoinManagerDelegate {
    func didUpdateRates(_ coinManager: CoinManager, rates: CoinModel) {
        DispatchQueue.main.async {
        self.currencyLabel.text = rates.selectedCurrency
            self.currencyRate.text = rates.rateString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

