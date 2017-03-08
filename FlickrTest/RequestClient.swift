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
    func loaded()
    func failed(withMessage message: String)
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
                
                if userData["stat"] as? String != "fail" {
                    self?.user.userName = username
                    self?.user.userID = userData.value(for: "user", "id") as! String
                    
                    self?.load(userDetailsWithUserID: (self?.user.userID)!)
                    
                } else {
                    self?.failed(withMessage: userData["message"] as! String)
                }
            }
        }
        
    }
    
    func load(userDetailsWithUserID userID: String){
        
        requestManager.perform(requestWithURLString: requestCreator.getURLString(forRequestType: .userDetailsFromUserID, withID: userID)) { [weak self] (success, data) in
            
            if success {
                
                guard let userData = data as? [String:AnyObject] else { return }
                
                if userData["stat"] as? String != "fail" {
                    
                    self?.user.totalPhotos = Int(userData.value(for: "photos","total") as! String)!
                    
                    let allUserPhotos = userData.value(for: "photos", "photo") as! [[String:AnyObject]]
                    
                    if allUserPhotos.count == 0 {
                        self?.failed(withMessage: "No Public Photos")
                    }
                    
                    for photo in allUserPhotos {
                        
                        let photo = Photo(withID: photo["id"] as! String, andTitle: photo["title"] as! String)
                        photo.isFriend = false
                        photo.isFamily = false
                        
                        self?.user.photos.append(photo)
                    }
                    
                    self?.delegate?.loaded()
                    
                } else {
                    
                    self?.failed(withMessage: userData["message"] as! String)
                }
            }
        }
    }
    
    func load(imageDetailsForID imageID: String, completion: @escaping ((UIImage?, String) -> ())) {
        
        requestManager.perform(requestWithURLString: requestCreator.getURLString(forRequestType: .photoDetails, withID: imageID)) { [weak self] (success, data) in
            
            guard let imageURL = ((((data as! [String:AnyObject]).value(for: "sizes", "size") as? [[String:Any]])?[1])! as [String:Any])["source"] as? String else { return }
            
            self?.requestManager.perform(requestWithURLString: imageURL, completionHandler: { (success, data) in

                if data is UIImage {
                    completion(data as? UIImage, imageID)
                }
                
            })
            
        }
    }

    func failed(withMessage message: String) {
        self.delegate?.failed(withMessage: message)
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
