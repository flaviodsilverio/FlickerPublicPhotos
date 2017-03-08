//
//  File.swift
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
    
    var images = Images()
    
    init(withID photoID: String, andTitle title: String) {
        self.photoID = photoID
        self.title = title
    }
    
}

class Images : AnyObject {

    var thumbnail : UIImage?
    var original : UIImage?
    
    var thumbnailSource : String = ""
    var originalSource : String = ""

}
