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
    @IBOutlet weak var locationButton: UIButton!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.inputAccessoryView = UIView()
        searchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        //Used for animate the icon and give a visual feedback that the button was pressed
        changeLocationIcon(for: "location.fill")
        
        locationManager.requestLocation()
    }
    
    //Used for visual feedback when the app is using user actual location
    func changeLocationIcon(for icon: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.locationButton.setBackgroundImage(UIImage(systemName: icon), for: .normal)
        })
    }
}

//MARK: - Text Field delegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        changeLocationIcon(for: "location")
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        changeLocationIcon(for: "location")
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
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)\n Please try again later", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Location Manager delegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            
            changeLocationIcon(for: "location.fill")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
}

//MARK: - String protocol

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}
