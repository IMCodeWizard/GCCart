//
//  OrderItemViewModel.swift
//  GCCart
//
//  Created by Ninja on 21/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import Foundation
import UIKit


class OrderItemViewModel {
    
    let name, pricePerType, total, quantity: String
    let substitutable: Bool
    
    init(orderItem: OrderItemInformation) {
        self.name = orderItem.product.name
        
        let price: Double = {
            switch orderItem.packagingType {
            case .Unit:
                return orderItem.product.unitPrice
            case .Case:
                return orderItem.product.casePrice
            case .Weight:
                return orderItem.product.weightPrice
            }
        }()
        
        self.pricePerType = String(price.formattedPrice() + "/\(orderItem.packagingType.rawValue.capitalized)")
        self.total = String(orderItem.subTotal.formattedPrice())
        self.quantity = String(orderItem.quantity)
        self.substitutable = orderItem.substitutable
    }

    
}
