//
//  WeatherManager.swift
//  Weather-Swift
//
//  Created by Elberte on 20/09/22.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    
    //Completes the URL that user enters in the search text field
    func fetchWeather(cityName: String) {
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
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    parseJSON(with: safeData)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(with weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.weather[0].description)
        } catch {
            print(error)
        }
    }
}
