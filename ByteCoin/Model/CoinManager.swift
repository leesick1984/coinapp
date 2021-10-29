import Foundation

protocol CoinManagerDelegate {
    func didUpdateRates(_ coinManager: CoinManager, rates: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "F21EA5A4-C7F1-4BE8-A6AB-3BF26E269817"
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency : String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
                }
                if let safeData = data {
                    if let rates = self.parseJson(safeData) {
                        self.delegate?.didUpdateRates(self, rates : rates)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ coinData : Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            let currency = decodedData.asset_id_quote

            let rates = CoinModel(rate: rate, selectedCurrency: currency)
            return rates
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
