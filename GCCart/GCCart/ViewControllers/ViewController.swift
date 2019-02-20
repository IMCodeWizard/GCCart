//
//  ViewController.swift
//  GCCart
//
//  Created by Ninja on 20/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        NetworkService.sharedService.sendRequestWithService(api: API.getCartItems(), success: { [weak self] (cartInfo: CartInfoData) in
            cartInfo.orderItemsInformation.forEach({print($0.packagingType)})
        }, failure: { (error) in
            print(error)
        })
    }
}

