//
//  AddressModel.swift
//  SeeWorld
//
//  Created by Raphael on 11/14/17.
//  Copyright © 2017 Raphael. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class WeatherClient {
    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "8d07dc0456656e99d50a7f6c050df180"
    
    weak var delegate : TextResultHandlerDelegate?
    
    func retrieveWeatherData(_ textView: UITextView, _ lat: Float, _ lon: Float) {
        let session = URLSession.shared
        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(lat)&lon=\(lon)")!
        var result = "There's "
        
        // The data task retrieves the data.
        let dataTask = session.dataTask(with: weatherRequestURL as URL) {
            (data : Data?, response : URLResponse?, error : Error?) in
            if let error = error {
                print("Error:\n\(error)")
                return
            }
            else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:  .mutableContainers) as! [String:AnyObject]
                    
                    if let data = json["weather"] as? [[String: Any]] {
                        for jsonDict in data {
                            let weather = jsonDict["description"] as? String
                            result += weather!
                            break;
                        }
                    }
                    
                    let temp = json["main"]!["temp"] as! Double
                    result += " outside, and the temperature is "
                    result += String(format: "%.0f", (temp - 273.15) * 1.8 + 32)
                    result += " degrees fahrenheit."
                    
                    self.delegateResponseHandling(response: result)
                }
                catch let jsonError as NSError {
                    print("JSON error description: \(jsonError.description)")
                }
            }
        }
        dataTask.resume()
    }
    
    private func delegateResponseHandling(response : String) {
        if (self.delegate != nil) {
            self.delegate?.handleTextResult(result: response, shouldAppendOriginalResponse: false)
        }
    }

}


