//
//  UIViewExtensions.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 08/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import Foundation
import UIKit


extension UIView {

    func set(isLoading: Bool){
    
        if isLoading {
        
            if self.viewWithTag(-101) != nil {
                return
            } else {
                let indicator = UIActivityIndicatorView(frame: self.bounds)
                indicator.startAnimating()
                indicator.tag = -101
                indicator.backgroundColor = UIColor.gray
                self.addSubview(indicator)
            }
            
        } else {
            self.viewWithTag(-101)?.removeFromSuperview()
        }
        
    }
    
    func show(noDataViewWithText text: String) {
        
        let label = self.viewWithTag(-102) as? UILabel ?? UILabel()
        label.tag = -102
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = text
        label.textAlignment = .center
        self.addSubview(label)
    
    }
    
    func hideNoDataView(){
        self.viewWithTag(-102)?.removeFromSuperview()
    }
    
    func bindFrameToSuperviewBounds(){
        
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }

}
