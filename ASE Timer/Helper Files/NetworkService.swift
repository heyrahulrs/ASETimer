//
//  NetworkService.swift
//  ASE Timer
//
//  Created by Rahul on 7/23/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//

import UIKit

var databaseURL: URL? {
    let url = URL(string: "https://asetimer.firebaseio.com/.json")
    return url
}

class NetworkService {
    
    static var shared = NetworkService()
    
    func getLocalEventInfo(_ completion: @escaping (ASE) -> Void) {
        
    }
    
    func downloadEventInfo(_ completion: @escaping (ASE) -> Void) {
        
        guard let databaseURL = databaseURL else {
            print("Error: cannot create URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: databaseURL) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Error: Data not convertable to JSON")
                    return
                }
                
                let event = ASE(json: json)
                
                DispatchQueue.main.async {
                    completion(event)
                }
                
            } catch{
                print("Error: error trying to convert data to JSON")
                return
            }
            
        }
        
        task.resume()
    }
    
    func downloadBackgroundImage(for event: ASE, _ completion: @escaping (UIImage) -> Void) {
        
        guard let backgroundImageURL = event.backgroundImageURL else { return }
        
        URLSession.shared.dataTask(with: backgroundImageURL) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            if let image = UIImage(data: data) {
                completion(image)
            }
            
        }.resume()
        
    }
    
}
