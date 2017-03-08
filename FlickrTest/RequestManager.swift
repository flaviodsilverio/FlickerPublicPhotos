//
//  RequestManager.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 07/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import Foundation

class RequestManager {
    
    func perform(requestWithURLString urlString: String,
                 completionHandler completion: @escaping (_ success: Bool, _ data : Any?) -> ()) {
        
        let url = URL(string: urlString)
        
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 200 {
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    completion(true, json)
                    
                } catch {
                    completion(true, data)
                }
                
            } else {
                
            }
            
            }.resume()
    }
    
}

