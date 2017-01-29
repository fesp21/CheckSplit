//
//  ContactTableViewCell.swift
//  canIhideProgrammaticElementsWithinASubview
//
//  Created by Henry Dinhofer on 1/26/17.
//  Copyright © 2017 Henry Dinhofer. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var splitWithLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    var newNameLabel : UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        print("am i selected \(selected)")
        checkmarkView.image = selected ? UIImage(named: "circle (checked).png") : UIImage(named: "circle (empty).png")
        
        
        
        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        //selectionStyle = .none
        
        nameLabel.font = UIFont(name: "AvenirNext-Medium", size: 16)
        splitWithLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
    }
}
