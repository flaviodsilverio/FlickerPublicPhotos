//
//  RequestManager.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 07/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import Foundation
import UIKit

class RequestManager {
    
    func perform(requestWithURLString urlString: String,
                 completionHandler completion: @escaping (_ success: Bool, _ data : Any?) -> ()) {
        
        let url = URL(string: urlString)
        
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 200 {
                
                if let image = UIImage(data: data!) {
                    completion(true, image)
                    
                } else {
                    
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        completion(true, json)
                        
                    } catch {
                        completion(false, ["message":"Error Parsing JSON"])
                    }}
                
            } else {
                completion(false, ["message":"Bad Request"])

            }
            }.resume()
    }
    
}

