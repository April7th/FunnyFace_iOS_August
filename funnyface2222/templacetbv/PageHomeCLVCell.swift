//
//  PageHomeCLVCell.swift
//  FutureLove
//
//  Created by khongtinduoc on 9/24/23.
//

import UIKit

class PageHomeCLVCell: UICollectionViewCell {
    @IBOutlet weak var pageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        pageLabel.font = .quickSandSemiBold(size: 24)
        pageLabel.textColor = .black
    }

}
