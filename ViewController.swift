//
//  ViewController.swift
//  WeatherApp
//
//  Created by Muazzam.Aziz on 2023/03/04.
//
import UIKit

struct APIResponse: Codable {
    let forecasts: [Result]
}

struct Result: Codable {
    let date: String
    let temp: Int
    let humidity: Int
    let windSpeed: Int
    let safe: Bool
}

class ViewController: UIViewController {
    
    @IBOutlet weak var safeLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nextDayButton: UIButton!
    let urlString = "https://run.mocky.io/v3/1fd068d7-cbb2-4ceb-b697-da7fcc1c520b"
    var result: [Result] = []
    var count = 0
    var dataSize: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
//        dateLabel.text = self.result[0].date
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func fetchData() {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Print data string
//            let dataString = self?.dataToString(data: data)
//            print("DataString: ", dataString)
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
//                print(jsonResult.forecasts.count)
                DispatchQueue.main.async {
                    self?.result = jsonResult.forecasts
                    self?.dataSize = jsonResult.forecasts.count
                    self?.dateLabel.text = "Date: \(jsonResult.forecasts[self?.count ?? 0].date)"
                    self?.tempLabel.text = "Temperatue: \(jsonResult.forecasts[self?.count ?? 0].temp)"
                    self?.humidityLabel.text = "Humidity Level: \(jsonResult.forecasts[self?.count ?? 0].humidity)"
                    self?.windspeedLabel.text = "Wind Speed Level: \(jsonResult.forecasts[self?.count ?? 0].windSpeed)"
                    self?.safeLabel.text = "Safe: \(jsonResult.forecasts[self?.count ?? 0].date)"
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    @IBAction func nextDayPressed(_ sender: UIButton) {
        count += 1
        if count <= dataSize - 1 {
            fetchData()
        }
        
    }
    func dataToString(data: Data) -> String {
        let dataString = String(decoding: data, as: UTF8.self)
        return dataString
    }
}



