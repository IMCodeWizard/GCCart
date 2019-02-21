//
//  Extensions.swift
//  GCCart
//
//  Created by Ninja on 20/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import Foundation

extension Decodable {
    static func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
}

extension Double {
    
    func formattedPrice(forCurrencyCode code: String = "USD") -> String {
        let currencyFormatter = NumberFormatter()
//        currencyFormatter.maximumFractionDigits = 0
        currencyFormatter.allowsFloats = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_"+code.dropLast())
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let priceString = currencyFormatter.string(from: NSNumber(value: self / 100.0))!
        return priceString
    }
    
}

