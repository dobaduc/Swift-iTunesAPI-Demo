//
//  Price.swift
//  iTunesSearch
//
//  Created by Doba Duc on 12/28/15.
//  Copyright © 2015 Ducky Duke. All rights reserved.
//

import Foundation

struct Price {
    let amount: String
    let currencyCode: String

    var formattedValue: String {
        let convertPrice = NSNumber(double: (amount as NSString).doubleValue)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.currencyCode = currencyCode

        let convertedPrice = formatter.stringFromNumber(convertPrice)
        return convertedPrice!
    }
}