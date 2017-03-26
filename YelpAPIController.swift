//
//  YelpAPIController.swift
//  PlaceFinder
//
//  Created by 潘捷 on 2017-03-12.
//  Copyright © 2017 SMU. All rights reserved.
//

import UIKit
import CoreLocation

protocol YelpAPIControllerProcol {
    func didReceiveAPIResults(results: [[String: Any]])
}

class YelpAPIController {
    
    let clientID = "odM7WqRsORcMsFymWEMiAw"
    let clientSecret = "Z73653VYs6SruZsfeySqHxDkSOuJ6DFHyp3Y7pOmhmT00WfHA3tYFTsvfD7CQpQG"
    var delegate: YelpAPIControllerProcol?
    
    func getAuthToken(callback: @escaping(String) -> ()) {
        let session = URLSession.shared
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.yelp.com"
        urlComponent.path = "/oauth2/token"
        
        if let url = urlComponent.url {
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = "POST"
            
            let parameters = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)"
            request.httpBody = parameters.data(using: String.Encoding.ascii, allowLossyConversion: true)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, request, error) -> Void in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    if let receivedData = data, let jsonResult = try? JSONSerialization.jsonObject(with: receivedData, options: []) as? [String: Any] {
                        print(jsonResult ?? "no result")
                        let tokenValue = jsonResult!["access_token"] as? String
                        callback(tokenValue!)
                    }
                }
            })
            
            task.resume()
            
        }
        
        
    }
    
    func tokenStored() -> String? {
        var token: String?
        if let tokenValue = UserDefaults.standard.value(forKey: "yelpToken") as? String {
            token = tokenValue
        } else {
            getAuthToken() { (response) in
                let tokenValue = response
                UserDefaults.standard.setValue(tokenValue, forKey: "yelpToken")
                UserDefaults.standard.synchronize()
                token = tokenValue
                
            }
        }
        return token
    }
    
    func getBusinessSearch(location: CLLocation, term: String, hotAndNew: Bool, cashback: Bool) {
        guard let token = tokenStored() else {
            print("no token stored")
            return
        }
        
        let session = URLSession.shared
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.yelp.com"
        urlComponent.path = "/v3/businesses/search"
        
        let radius = 5000
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        var attributesString = ""
        if hotAndNew == true {
            attributesString = "hot_and_new"
            if cashback == true {
                attributesString.append(",cashback")
            }
        } else {
            if cashback == true {
                attributesString = "cashback"
            }
        }
        urlComponent.queryItems = [
            URLQueryItem(name: "term", value: String(term)),
            URLQueryItem(name: "radius", value: String(radius)),
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude))
        ]
        if attributesString != "" {
            let attributes = URLQueryItem(name: "attributes", value: attributesString)
            urlComponent.queryItems?.append(attributes)
        }
        if let url = urlComponent.url {
            let request = NSMutableURLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) -> Void in
                if (error != nil) {
                    print("error", error?.localizedDescription ?? "")
                } else {
                    if let receivedData = data, let jsonResult = try? JSONSerialization.jsonObject(with: receivedData, options: .allowFragments) as? [String: Any] {
                        print(jsonResult!)
                        if let businesses = jsonResult!["businesses"] as? [[String: Any]] {
                            self.delegate?.didReceiveAPIResults(results: businesses)
                        }
                        
                    }
                }
            })
            task.resume()
        }
        
    }
    
}
