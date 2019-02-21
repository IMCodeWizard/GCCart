//
//  DataObjects.swift
//  GCCart
//
//  Created by Ninja on 20/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import Foundation

struct CartInfoData: Codable {
    let id, restaurantID: Int
    let total, subTotal: Double
    let status, deliveryAddress, deliveryDate, paymentMethod, createdAtIso8601: String
    let orderItemsInformation: [OrderItemInformation]
    
    enum CodingKeys: String, CodingKey {
        case id, total, status
        case restaurantID = "restaurant_id"
        case subTotal = "sub_total"
        case createdAtIso8601 = "created_at_iso8601"
        case deliveryAddress = "delivery_address"
        case deliveryDate = "delivery_date"
        case paymentMethod = "payment_method"
        case orderItemsInformation = "order_items_information"
    }
}

class OrderItemInformation: Codable {
    let id, orderID, quantity, productID: Int
    let subTotal: Double
    let packagingType: PackagingType
    let substitutable: Bool
    let product: Product
    
    enum CodingKeys: String, CodingKey {
        case id, quantity, substitutable, product
        case productID = "product_id"
        case subTotal = "sub_total"
        case orderID = "order_id"
        case packagingType = "packaging_type"
    }
}

enum PackagingType: String, Codable {
    case Case = "case"
    case Unit = "unit"
    case Weight = "weight"
}

struct Product: Codable {
    let id, itemsPerUnit, unitsPerCase: Int
    let unitPrice, casePrice, weightPrice: Double
    let name, unitPhotoFilename, packPhotoFile, unitPhotoHqURL, packPhotoHqURL, weightPhotoFilename, weightPhotoHqURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case unitPrice = "unit_price"
        case casePrice = "case_price"
        case weightPrice = "weight_price"
        case itemsPerUnit = "items_per_unit"
        case unitsPerCase = "units_per_case"
        case unitPhotoFilename = "unit_photo_filename"
        case packPhotoFile = "pack_photo_file"
        case unitPhotoHqURL = "unit_photo_hq_url"
        case packPhotoHqURL = "pack_photo_hq_url"
        case weightPhotoFilename = "weight_photo_filename"
        case weightPhotoHqURL = "weight_photo_hq_url"
    }
}
