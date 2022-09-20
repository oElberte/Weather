//
//  ViewController.swift
//  Weather-Swift
//
//  Created by Elberte on 16/09/22.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherManager.delegate = self
        searchTextField.inputAccessoryView = UIView()
        searchTextField.delegate = self
    }
}

//MARK: - Text Field delegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(from: city)
        }
        
        searchTextField.text = ""
    }
}

//MARK: - Weather Manager delegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        temperatureLabel.text = weather.temperatureString
        
        cityLabel.text = weather.cityName
        
        descriptionLabel.text = String(weather.description).firstUppercased
        
        conditionImageView.image = UIImage(systemName: weather.conditionName)
    }
    
    func didFailWithError(_ error: Error) {
        //TODO: implement error
        print("ERROR: \(error)")
    }
}

//MARK: - String protocol

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}
