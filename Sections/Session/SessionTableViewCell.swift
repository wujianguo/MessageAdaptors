//
//  SessionTableViewCell.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/24.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import Kingfisher
import MessageKit

class SessionTableViewCell<SessionType: MessageSession>: UITableViewCell {
    
    static func identifier() -> String {
        return "SessionTableViewCellIdentifier"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var session: SessionType! {
        didSet {
            update()
        }
    }
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
        return label
    }()
    
    func setup() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leadingMargin, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .topMargin, multiplier: 1, constant: 0))
        avatarImageView.addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .width, relatedBy: .equal, toItem: avatarImageView, attribute: .height, multiplier: 1, constant: 0))

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: -UIConstants.padding/2))
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: avatarImageView, attribute: .trailing, multiplier: 1, constant: UIConstants.padding))
        contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: timeLabel, attribute: .leading, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .firstBaseline, relatedBy: .equal, toItem: timeLabel, attribute: .firstBaseline, multiplier: 1, constant: 0))
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: UIConstants.padding))
        contentView.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: 0))
    }
    
    func update() {
        avatarImageView.kf.setImage(with: session.avatarURL)
        nameLabel.text = session.displayName
        if let last = session.lastMessage {
            let formater = MessageKitDateFormatter.shared
            timeLabel.text = formater.string(from: last.sentDate)
            messageLabel.text = last.messageContent
        } else {
            timeLabel.text = " "
            messageLabel.text = " "
        }
    }
}
