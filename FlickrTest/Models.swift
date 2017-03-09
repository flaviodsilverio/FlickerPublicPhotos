//
//  Models.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 08/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import UIKit

class User : AnyObject{
    
    var userID : String = ""
    var userName : String = ""
    var totalPhotos : Int = 0
    
    var photos = [Photo]()
}

class Photo : AnyObject{

    var title : String = ""
    var photoID : String = ""
    var description : String?
    var dateTaken : String?
    var posted : String?
    var updated : String?
    var totalComments : Int = 0
    var originalPost : URL?
    var views : String?
    
    var images = Images()
    
    init(withID photoID: String, andTitle title: String) {
        self.photoID = photoID
        self.title = title
    }
    
    func fill(withDetails details: [String:AnyObject]){
    
        guard let photoDetails = details["photo"] as? [String:AnyObject] else { return }
        
        description = photoDetails["description"] as? String
        dateTaken  = photoDetails.value(for: "dates", "taken") as? String
        posted = photoDetails.value(for: "dates", "posted") as? String
        updated = photoDetails.value(for: "dates", "taken") as? String
        views = photoDetails["views"] as? String

        if let originalLink = photoDetails.value(for: "urls", "url", "_content") as? String {
            originalPost = URL(string: originalLink)
        }
        
    }
    
}

class Images : AnyObject {

    var thumbnail : UIImage?
    var original : UIImage?
    
    var thumbnailSource : String = ""
    var originalSource : String = ""

}
