//
//  SessionTableViewCell.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/24.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

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
        
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.snp.leadingMargin)
            make.top.equalTo(contentView.snp.topMargin)
            make.width.equalTo(avatarImageView.snp.height)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView.snp.trailingMargin).priority(ConstraintPriority.high)
            make.bottom.equalTo(contentView.snp.centerY).offset(-UIConstants.padding/2)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(UIConstants.padding)
            make.trailing.lessThanOrEqualTo(timeLabel.snp.leading)
            make.firstBaseline.equalTo(timeLabel.snp.firstBaseline)
        }
        
        messageLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel.snp.leading)
            make.top.equalTo(nameLabel.snp.bottom).offset(UIConstants.padding)
        }
    }
    
    func update() {
        avatarImageView.kf.setImage(with: session.avatarURL)
        nameLabel.text = session.displayName
        if let last = session.messages.last {
            let formater = DateFormatter()
            formater.dateStyle = .none
            formater.timeStyle = .short
            timeLabel.text = formater.string(from: last.sentDate)
            messageLabel.text = last.messageContent
        }
    }
}
