//
//  EventCommentTableViewCell.swift
//  funnyface2222
//
//  Created by Lê Duy Tân on 6/8/24.
//

import UIKit

class EventCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!


    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        userNameLabel.font = .quickSandBold(size: 12)
        userNameLabel.textColor = .white
        commentLabel.textColor = UIColor(hex: "#bfbfbf")
        commentLabel.font = .quickSandSemiBold(size: 12)
        timeLabel.font = .quickSandRegular(size: 12)
        timeLabel.textColor = .white.withAlphaComponent(0.5)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
