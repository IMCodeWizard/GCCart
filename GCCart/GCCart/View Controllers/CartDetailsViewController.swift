//
//  ViewController.swift
//  GCCart
//
//  Created by Ninja on 20/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import UIKit

class CartDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var collectionData: [OrderItemViewModel]?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        NetworkService.sharedService.sendRequestWithService(api: API.getCartItems(), success: { [weak self] (cartInfo: CartInfoData) in
            cartInfo.orderItemsInformation.forEach({print($0.product.name)})
            
            self?.collectionData = cartInfo.orderItemsInformation.map({ return OrderItemViewModel(orderItem: $0)})
            self?.tableView.reloadData()
            
        }, failure: { (error) in
            print(error)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    //MARK: - UI Methods

    
    //MARK: - Custom Methods
}

//MARK: -
extension CartDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    /** Data Source */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collectionData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        let orderItem = collectionData![indexPath.row]
        
        cell.bindData(orderItem: orderItem)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.33, delay: 0, animations: {
            cell.transform = .identity
            cell.alpha = 1.0
        })
    }
    
    
    
}
