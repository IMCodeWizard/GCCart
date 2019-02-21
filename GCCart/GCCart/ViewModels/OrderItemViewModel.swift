//
//  OrderItemViewModel.swift
//  GCCart
//
//  Created by Ninja on 21/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class OrderItemViewModel {
    
    let name, pricePerType, total, quantity, imageUrl, packagingType: String
    let substitutable: Bool
    var photo: UIImage?
    var loadImageInProgress = false
    
    init(orderItem: OrderItemInformation) {
        self.name = orderItem.product.name
        self.packagingType = orderItem.packagingType.rawValue.capitalized
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
        
        self.imageUrl = {
            switch orderItem.packagingType {
            case .Unit:
                return orderItem.product.unitPhotoFilename
            case .Case:
                return orderItem.product.packPhotoFile
            case .Weight:
                return orderItem.product.weightPhotoFilename
            }
        }()
        
        self.pricePerType = String(price.formattedPrice() + "/\(orderItem.packagingType.rawValue.capitalized)")
        self.total = String(orderItem.subTotal.formattedPrice())
        self.quantity = String(orderItem.quantity)
        self.substitutable = orderItem.substitutable
    }
    
    func getProductPhoto(success: ((UIImage) -> Void)? = nil, failure: ((String) -> Void)? = nil) {
        
        if let photo = self.photo {
            success?(photo)
        }else{
            
            NetworkService.sharedService.loadImage(urlString: self.imageUrl, success: { [unowned self] (image) in
                self.photo = image
                success?(image)
            }, failure: { [unowned self] (error) in
                Logger.mainLog(className: String(describing: self), description: error)
                failure?(error)
            })
        }
        
        
        
    }
}
