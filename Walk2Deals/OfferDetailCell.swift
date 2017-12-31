//
//  OfferDetailCell.swift
//  Walk2Deals
//
//  Created by Madhav Bhogapurapu on 11/6/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
protocol ExpandCellDelegate {
    func moreTapped(cell: OfferDetailCell)
}
class OfferDetailCell: UITableViewCell {

    @IBOutlet var validStartFromLbl: UILabel!
    @IBOutlet var validEndOfferLbl: UILabel!
    @IBOutlet weak var viewMoreBtn: UIButton!
    @IBOutlet weak var descriptionLbl: UILabel!
    var delegate: ExpandCellDelegate?
    var isExpanded: Bool = false

    @IBAction func viewMoreAction(_ sender: UIButton) {
        isExpanded = !isExpanded
        descriptionLbl.numberOfLines = isExpanded ? 0 : 3
        viewMoreBtn.setTitle(isExpanded ? "View less" : "View more...", for: .normal)
        delegate?.moreTapped(cell: self)

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
