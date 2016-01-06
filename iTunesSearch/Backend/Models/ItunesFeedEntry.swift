//
//  ItunesFeedEntry.swift
//  iTunesSearch
//
//  Created by Doba Duc on 12/28/15.
//  Copyright © 2015 Ducky Duke. All rights reserved.
//

import Foundation
import ObjectMapper

class ItunesFeedEntry: Mappable {
    private(set) var id: String = ""
    private(set) var name: String = ""
    private(set) var summary: String = ""
    private(set) var price: Price = Price(amount: "0", currencyCode: "usd")
    private(set) var author: String = ""
    private(set) var category: String = ""
    private(set) var imageURL: String = ""
    private(set) var itunesURL: String = ""

    required init?(_ map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id.attributes.im:id"]
        name <- map["im:name.label"]
        summary <- map["summary.label"]

        price = Price(amount: map["im:price.attributes.amount"].value()!, currencyCode: map["im:price.attributes.currency"].value()!)

        author <- map["im:artist.label"]
        category <- map["category.label"]
        imageURL <- map["im:image.2.label"]
        itunesURL <- map["link.href"]
    }
}