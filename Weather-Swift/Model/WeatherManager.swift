//
//  WeatherManager.swift
//  Weather-Swift
//
//  Created by Elberte on 20/09/22.
//

import Foundation

//Delegate used to send informations to Weather View Controller
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    //Completes the URL that user enters in the search text field
    func fetchWeather(from cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    //Check for results in the OpenWeather API
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                //This code handle the data we receive back from OpenWeather API
                if error != nil {
                    delegate?.didFailWithError(error!)
                    return
                }
                
                //Send the weather informations to Weather View Controller setted as delegate
                if let safeData = data {
                    DispatchQueue.main.async {
                        if let weather = parseJSON(with: safeData) {
                            delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    //Decode the JSON from the API using the Weather Model
    func parseJSON(with weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            let desc = decodedData.weather[0].description
            
            let weather = WeatherModel(cityName: name, temperature: temp, conditionId: id, description: desc)
            return weather
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
