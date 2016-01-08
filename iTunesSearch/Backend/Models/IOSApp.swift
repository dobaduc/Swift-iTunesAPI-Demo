//
//  IOSApp.swift
//  iTunesSearch
//
//  Created by Duc DoBa on 1/7/16.
//  Copyright © 2016 Ducky Duke. All rights reserved.
//

import Foundation
import ObjectMapper

class IOSApp: ItunesSearchResultItem {
    private(set) var version: String = ""
    private(set) var description: String = ""
    private(set) var releaseNotes: String = ""
    private(set) var genres: [Genre] = []
    private(set) var screenshotUrls: [String] = []
    private(set) var supportedDevices: [String] = []
    private(set) var rating: String = ""
    
    override func mapping(map: Map) {
        super.mapping(map)
        version <- map["version"]
        description <- map["description"]
        releaseNotes <- map["releaseNotes"]
        supportedDevices <- map["supportedDevices"]
        genres <- map["genres"]
        rating <- map["averageUserRatingForCurrentVersion"]
    }
}