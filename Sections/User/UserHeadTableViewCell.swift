//
//  UserHeadTableViewCell.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/30.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import Kingfisher

class UserHeadTableViewCell: UITableViewCell {

    static func identifier() -> String {
        return "UserHeadTableViewCellIdentifier"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var user: MessageUser! {
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
    
    lazy var displayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
        return label
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
        return label
    }()
    
    
    func setup() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(displayLabel)
        contentView.addSubview(idLabel)
        
        avatarImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leadingMargin)
            make.centerY.equalTo(contentView)
            make.top.equalTo(contentView.snp.topMargin)
            make.width.equalTo(avatarImageView.snp.height)
        }
        
        displayLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(UIConstants.padding)
            make.trailing.equalTo(contentView.snp.trailingMargin)
            make.bottom.equalTo(contentView.snp.centerY).offset(-UIConstants.padding/2)
        }
        
        idLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(displayLabel.snp.leading)
            make.top.equalTo(displayLabel.snp.bottom).offset(UIConstants.padding)
            make.trailing.equalTo(contentView.snp.trailingMargin)
        }
    }
    
    func update() {
        avatarImageView.kf.setImage(with: user.avatarURL)
        displayLabel.text = user.displayName
        idLabel.text = "\(Strings.ID): \(user.id)"
    }

}
