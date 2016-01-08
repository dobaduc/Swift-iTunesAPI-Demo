//
//  ItunesSearchResultItem.swift
//  iTunesSearch
//
//  Created by Duc DoBa on 1/7/16.
//  Copyright © 2016 Ducky Duke. All rights reserved.
//

import Foundation
import ObjectMapper

class ItunesSearchResultItem: Mappable {
    private(set) var id: String = ""
    private(set) var name: String = ""
    private(set) var summary: String = ""
    private(set) var price: Price = Price(amount: "0", currencyCode: "usd")
    private(set) var author = Author(id: "", name: "", itunesURL: "")
    private(set) var imageURL: String = ""
    private(set) var itunesURL: String = ""
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["trackId"]
        name <- map["trackName"]
        price = Price(amount: map["trackPrice"].value()!, currencyCode: map["currency"].value()!)
        author = Author(id: map["artistId"].value()!, name: map["artistName"].value()!, itunesURL: map["artistViewUrl"].value()!)
        imageURL <- map["artworkUrl100"]
        itunesURL <- map["trackViewUrl"]
    }
}