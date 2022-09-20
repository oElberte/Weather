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
        performRequest(urlString)
    }
    
    //Check for results in the OpenWeather API
    func performRequest(_ urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            
            task.resume()
        }
    }
    
    //This function handle the data we receive back from OpenWeather API
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        }
    }
}
