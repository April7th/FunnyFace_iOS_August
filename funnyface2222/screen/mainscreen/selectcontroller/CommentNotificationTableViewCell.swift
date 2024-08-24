//
//  CommentNotificationTableViewCell.swift
//  funnyface2222
//
//  Created by Lê Duy Tân on 5/8/24.
//

import UIKit
import Kingfisher

class CommentNotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    
    
    var id_comment:String = ""
    var thoi_gian_release:String = ""
    var id_user_comment:String = ""
    var linkAvatar:String = ""
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setupUI() {
        descriptionLabel.font = .quickSandSemiBold(size: 12)
        timeLabel.font = .quickSandSemiBold(size: 10)
        timeLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        
    }

    
    func configCell(model: DataCommentEvent) {
        if let url = URL(string: model.avatar_user.asStringOrEmpty()) {
            avatarImage.af.setImage(withURL: url)
        }
        descriptionLabel.text = model.user_name
  
        let dateString = model.thoi_gian_release.asStringOrEmpty()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let targetDate = dateFormatter.date(from: dateString) else {
            return
        }
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate, to: currentDate)
        var result = ""
        if let days = components.day, days > 2 {
            result = "\(dateString)"
        } else if let days = components.day, days > 0 {
            result = "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            result = "\(hours) hour ago"
        } else if let minutes = components.minute, minutes > 0 {
            result = "\(minutes) min ago"
        } else if let seconds = components.second, seconds > 0 {
            result = "\(seconds) sec ago"
        } else {
            result = "now"
        }
        self.timeLabel.text = result
    }

    func configCellComment(model: DataComment) {
//        if let url = URL(string: model.avatar_user.asStringOrEmpty()) {
//            imageAvatar.af.setImage(withURL: url)
//        }
        if let url = URL(string: model.avatar_user.asStringOrEmpty() ?? "") {
            let processor = DownsamplingImageProcessor(size: avatarImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 20)
            avatarImage.kf.indicatorType = .activity
            avatarImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: "hoapro"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
        
        descriptionLabel.text = model.user_name
       
        let dateString = model.thoi_gian_release.asStringOrEmpty()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let targetDate = dateFormatter.date(from: dateString) else {
            return
        }
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate, to: currentDate)
        var result = ""
        if let days = components.day, days > 2 {
            result = "\(dateString)"
        } else if let days = components.day, days > 0 {
            result = "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            result = "\(hours) hour ago"
        } else if let minutes = components.minute, minutes > 0 {
            result = "\(minutes) min ago"
        } else if let seconds = components.second, seconds > 0 {
            result = "\(seconds) sec ago"
        } else {
            result = "now"
        }
        self.timeLabel.text = result
      
    }
    
    func configCellReComment(model: CommentUser) {
        if let url = URL(string: model.avatar_user.asStringOrEmpty()) {
            avatarImage.af.setImage(withURL: url)
        }
        descriptionLabel.text = model.user_name
        
        let dateString = model.thoi_gian_release.asStringOrEmpty()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let targetDate = dateFormatter.date(from: dateString) else {
            return
        }
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate, to: currentDate)
        var result = ""
//        if let years = components.year, years > 0 {
//            result = "\(years) years ago"
//    } else
        if let days = components.day, days > 2 {
            result = "\(dateString)"
        } else if let days = components.day, days > 0 {
            result = "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            result = "\(hours) hour ago"
        } else if let minutes = components.minute, minutes > 0 {
            result = "\(minutes) min ago"
        } else if let seconds = components.second, seconds > 0 {
            result = "\(seconds) sec ago"
        } else {
            result = "Now"
        }
        self.timeLabel.text = result
      
    }
}



