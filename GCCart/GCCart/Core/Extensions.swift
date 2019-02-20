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
