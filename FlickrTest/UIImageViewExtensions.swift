//
//  UIImageViewExtensions.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 08/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func setImage(forItem item: Photo, inPosition position: Int) {
    
        if item.images.thumbnail == nil {
            
            self.image = UIImage(named:"placeholder")
            self.tag = position
            
            RequestClient.sharedInstance.load(imageSizesForID: item.photoID, completion: {
                [weak self] (image : UIImage?, imageID : String)  in
                
                if position == self?.tag {
                    DispatchQueue.main.sync {
                        self?.image = image
                    }
                }
                
                item.images.thumbnail = image
            })
            
        } else {
            self.image = item.images.thumbnail
        }
        
    
    }
    
}
