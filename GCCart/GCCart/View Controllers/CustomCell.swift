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
    
    func bindData(orderItem: OrderItemViewModel) {
        self.pName.text = orderItem.name
        self.pPricePerType.attributedText = applyStyle(for: orderItem.pricePerType, atText: orderItem.packagingType)
        self.pTotal.text = orderItem.total
        self.pQuantity.text = orderItem.quantity
        self.pSubstitutableIndicator.isHighlighted = orderItem.substitutable
        
        /** Image Handler */
        self.pPicture.image = nil
        self.spinner.startAnimating()
        orderItem.getProductPhoto(success: { [weak self] (image) in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.pPicture.image = image
            }
        }) { [weak self] (error) in
            self?.spinner.stopAnimating()
            self?.pPicture.image = UIImage(named: "picture")
            self?.pPicture.contentMode = .scaleAspectFit
        }
    }
    
    /** Price per type stype */
    private func applyStyle(for text: String, atText: String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        let range = attrString.mutableString.range(of: atText, options: .caseInsensitive)
        let attributes = [
            .foregroundColor : #colorLiteral(red: 0.9725490196, green: 0.9058823529, blue: 0.1098039216, alpha: 1),
            .font : UIFont.boldSystemFont(ofSize: 17)
            ] as [NSAttributedString.Key : Any]
        attrString.setAttributes(attributes, range: NSMakeRange(range.location, atText.count))
        return NSAttributedString(attributedString: attrString)
    }

}
