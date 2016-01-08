//
//  Software.swift
//  iTunesSearch
//
//  Created by Doba Duc on 12/28/15.
//  Copyright © 2015 Ducky Duke. All rights reserved.
//

import Foundation
import ObjectMapper

class IOSAppFeedEntry: ItunesFeedEntry {
    private(set) var bundleID: String?

    required init?(_ map: Map) {
        super.init(map)
    }

    override func mapping(map: Map) {
        super.mapping(map)
        bundleID <- map["id.attributes.im:bundleId"]
    }
}