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

final class RequestClient {

    let requestManager = RequestManager()
    let requestCreator = RequestCreator()
    
    weak var delegate : RequestClientDelegate?
    
    static let sharedInstance = RequestClient()
    
    unowned var user = User()
    
    func load(userWithName username: String){
        
        requestManager.perform(requestWithURLString: requestCreator.getURLString(forRequestType: .userIDFromName, withID: username))
        { [weak self] (success, data) in
            
            if success {
                guard let userData = data as? [String:AnyObject] else { return }
                
                self?.user.userName = username
                self?.user.userID = userData.value(for: "user", "id") as! String
                
                self?.load(userDetailsWithUserID: (self?.user.userID)!)
            }
        }
        
    }
    
    func load(userDetailsWithUserID userID: String){
        
        requestManager.perform(requestWithURLString: "https://api.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=519bef96f3f1304e71258378481aea09&user_id=142226915%40N06&per_page=500&page=2&format=json&nojsoncallback=1") { [weak self] (success, data) in
            
            if success {
                guard let userData = data as? [String:AnyObject] else { return }
                
                self?.user.totalPhotos = Int(userData.value(for: "photos","total") as! String)!
                
                let allUserPhotos = userData.value(for: "photos", "photo") as! [[String:AnyObject]]
                
                for photo in allUserPhotos {
                    self?.user.photos.append(Photo(withID: photo["id"] as! String, andTitle: photo["title"] as! String))
                }
                
                self?.delegate?.loaded(userPhotos: [])
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

final class RequestCreator {

    enum RequestType {
        case photoDetails
        case userIDFromName
        case userDetailsFromUserID
    }
    
    var requestType = RequestType.userIDFromName
    
    let baseHead = "https://api.flickr.com/services/rest/?method="
    let apiKey = "&api_key=519bef96f3f1304e71258378481aea09&"
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
