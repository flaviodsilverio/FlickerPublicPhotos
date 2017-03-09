//
//  RequestClient.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 07/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import Foundation
import UIKit

final class RequestClient {

    let requestManager = RequestManager()
    let requestCreator = RequestCreator()
    
    static let sharedInstance = RequestClient()
    
    var queue = OperationQueue()
    
    unowned var user = User()
    
    func load(userWithName username: String,
              completion: @escaping ((_ success: Bool, _ message: String?)->())){
        
            requestManager.perform(requestWithURLString: requestCreator.getURLString(forRequestType: .userIDFromName, withID: username))
            { [weak self] (success, data) in
                
                if success {
                    guard let userData = data as? [String:AnyObject] else { completion(false, "something went wrong"); return  }
                    
                    if userData["stat"] as? String != "fail" {
                        self?.user.userName = username
                        self?.user.userID = userData.value(for: "user", "id") as! String
                        
                        self?.load(userDetailsWithUserID: (self?.user.userID)!, completion: completion)
                        
                    } else {
                        completion(false, userData["message"] as? String)
                    }
                } else {
                    completion(false, data as? String)
                }
            }
    }
    
    func load(userDetailsWithUserID userID: String,
              completion: @escaping ((_ success: Bool, _ message: String?)->())){
        
        requestManager.perform(requestWithURLString: requestCreator.getURLString(forRequestType: .userDetailsFromUserID, withID: userID)) { [weak self] (success, data) in
            
            if success {
                
                guard let userData = data as? [String:AnyObject] else { completion(false, "something went wrong"); return  }
                
                if userData["stat"] as? String != "fail" {
                    
                    self?.user.totalPhotos = Int(userData.value(for: "photos","total") as! String)!
                    
                    let allUserPhotos = userData.value(for: "photos", "photo") as! [[String:AnyObject]]
                    
                    if allUserPhotos.count == 0 {
                        completion(false, "User has no Public Photos")
                    }
                    
                    for photo in allUserPhotos {
                        
                        let photo = Photo(withID: photo["id"] as! String, andTitle: photo["title"] as! String)
                        
                        self?.user.photos.append(photo)
                    }
                    
                    completion(true,nil)
                    
                } else {
                    completion(false, userData["message"] as? String)
                }
            
            } else {
                completion(false, data as? String)
            }
        }
    }
    
    func load(photoDetailsForPhoto photo: Photo,
              completion: @escaping ((_ success: Bool, _ message: String?)->())) {
        
        requestManager.perform(requestWithURLString: requestCreator.getURLString(forRequestType: .photoDetails, withID: photo.photoID)) { (success, data) in
            
            guard let userData = data as? [String:AnyObject] else { completion(false, "something went wrong"); return }
            
            if success {
                
                photo.fill(withDetails: data as! [String : AnyObject])
                completion(true, nil)
                
            } else {
                completion(false, userData["message"] as? String)
            }
            
            
        }
    }
    
    func load(imageSizesForID imageID: String,
              completion: @escaping ((UIImage?, String) -> ())) {
        
        requestManager.perform(requestWithURLString: requestCreator.getURLString(forRequestType: .photoSizes, withID: imageID)) { [weak self] (success, data) in
            
            guard let imageURL = ((((data as! [String:AnyObject]).value(for: "sizes", "size") as? [[String:Any]])?[1])! as [String:Any])["source"] as? String else { return }
            
            self?.requestManager.perform(requestWithURLString: imageURL, completionHandler: { (success, data) in

                if data is UIImage {
                    completion(data as? UIImage, imageID)
                }
                
            })
            
        }
    }

}

final class RequestCreator {
    
    enum RequestType {
        case photoDetails
        case userIDFromName
        case userDetailsFromUserID
        case photoSizes
    }
    
    var requestType = RequestType.userIDFromName
    
    let baseHead = "https://api.flickr.com/services/rest/?method="
    let apiKey = "&api_key=9f4a74831f5da6d71ed16cb11d955600&"
    let baseTail = "&format=json&nojsoncallback=1"
    
    func getURLString(forRequestType requestType: RequestType, withID id: String) -> String {
        
        var method = ""
        var idType = ""
        
        switch requestType {
        case .photoSizes:
            method = "flickr.photos.getSizes"
            idType = "photo_id="
            break
        case .photoDetails:
            method = "flickr.photos.getInfo"
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
