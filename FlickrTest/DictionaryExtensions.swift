//
//  DictionaryExtensions.swift
//  FlickrTest
//
//  Created by Flávio Silvério on 07/03/17.
//  Copyright © 2017 Flávio Silvério. All rights reserved.
//

import Foundation

extension Dictionary {
    func value(for keyPath: Key...) -> Any? {
        guard let lastComponent = keyPath.last else { return nil }
        let dictionary: [Key: Any]? = keyPath.dropLast().reduce(self) { $0?[$1] as? [Key: Any] }
        return dictionary?[lastComponent]
    }
}
