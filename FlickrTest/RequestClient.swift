//
//  RequestClient.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 07/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import Foundation
import UIKit

protocol RequestClientDelegate : class{
    func loaded(userPhotos photos: [ImageHelper])
}

class RequestClient {

    let requestManager = RequestManager()
    
    weak var delegate : RequestClientDelegate?
    
    let requestCreator = RequestCreator()
    
    func load(userWithName username: String){
        
        requestManager.perform(requestWithURLString: requestCreator.getURLString(forRequestType: .userIDFromName, withID: username))
        { [weak self] (success, data) in
            
            if success {
                guard let userData = data as? [String:AnyObject] else { return }
                self?.load(userDetailsWithUserID: userData.value(for: "user", "id") as! String)
            }
        }
        
    }
    
    func load(userDetailsWithUserID userID: String){
        requestManager.perform(requestWithURLString: requestCreator.getURLString(forRequestType: .userDetailsFromUserID, withID: userID)) { [weak self] (success, data) in
            
            if success {
                guard let userData = data as? [String:AnyObject] else { return }
                
                var photosArray = [ImageHelper]()
                
                for photo in userData.value(for: "photos", "photo") as! [[String:AnyObject]] {
                    let helper = ImageHelper()
                    helper.imageID = photo["id"] as! String
                    photosArray.append(helper)
                }
                
                self?.delegate?.loaded(
                    userPhotos: photosArray)
            }
            
        }
    }
    
    func load(imageDetailsForID imageID: String, completion: @escaping ((UIImage?, String) -> ())) {
        
        requestManager.perform(requestWithURLString: requestCreator.getURLString(forRequestType: .photoDetails, withID: imageID)) { [weak self] (success, data) in
            
            guard let imageURL = ((((data as! [String:AnyObject]).value(for: "sizes", "size") as? [[String:Any]])?[1])! as [String:Any])["source"] as? String else { return }
            
            self?.requestManager.perform(requestWithURLString: imageURL, completionHandler: { (success, data) in
                
                let image = UIImage(data: data! as! Data)
                completion(image, imageID)
                
            })
            
        }
    }

}

class RequestCreator {

    enum RequestType {
        case photoDetails
        case userIDFromName
        case userDetailsFromUserID
    }
    
    var requestType = RequestType.userIDFromName
    
    let baseHead = "https://api.flickr.com/services/rest/?method="
    let apiKey = "&api_key=956355626648d3053ddfec23e6b26d7f&"
    let baseTail = "&format=json&nojsoncallback=1"
    
    func getURLString(forRequestType requestType: RequestType, withID id: String) -> String {
        
        var method = ""
        var idType = ""
        
        switch requestType {
        case .photoDetails:
            method = "flickr.photos.getSizes"
            idType = "photo_id="
            break
        case .userDetailsFromUserID:
            method = "flickr.people.getPublicPhotos"
            idType = "user_id="
            break
        default:
            method = "flickr.people.findByUsername"
            idType = "username="
        }
        
        return baseHead + method + apiKey + idType + id + baseTail
    }
    
    
}
