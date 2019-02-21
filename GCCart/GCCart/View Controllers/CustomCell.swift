//
//  CustomCell.swift
//  GCCart
//
//  Created by Ninja on 21/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var pPicture: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var pName: UILabel!
    @IBOutlet weak var pPricePerType: UILabel!
    @IBOutlet weak var pSubstitutableIndicator: UIImageView!
    @IBOutlet weak var pTotal: UILabel!
    @IBOutlet weak var pQuantity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(orderItem: OrderItemViewModel) {
        self.pName.text = orderItem.name
        self.pPricePerType.text = orderItem.pricePerType
        self.pTotal.text = orderItem.total
        self.pQuantity.text = orderItem.quantity
    }

}
