//
//  UserHeadTableViewCell.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/30.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import Kingfisher

class UserHeadTableViewCell: StatictableViewCell {

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
    
    override var height: CGFloat {
        return 80
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
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leadingMargin, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .topMargin, multiplier: 1, constant: 0))
        avatarImageView.addConstraint(NSLayoutConstraint(item: avatarImageView, attribute: .width, relatedBy: .equal, toItem: avatarImageView, attribute: .height, multiplier: 1, constant: 0))
        
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: displayLabel, attribute: .leading, relatedBy: .equal, toItem: avatarImageView, attribute: .trailing, multiplier: 1, constant: UIConstants.padding))
        contentView.addConstraint(NSLayoutConstraint(item: displayLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: displayLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: -UIConstants.padding/2))

        idLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: idLabel, attribute: .leading, relatedBy: .equal, toItem: displayLabel, attribute: .leading, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: idLabel, attribute: .top, relatedBy: .equal, toItem: displayLabel, attribute: .bottom, multiplier: 1, constant: UIConstants.padding))
        contentView.addConstraint(NSLayoutConstraint(item: idLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: 0))        
    }
    
    func update() {
        avatarImageView.kf.setImage(with: user.avatarURL)
        displayLabel.text = user.displayName
        idLabel.text = "\(Strings.ID): \(user.id)"
    }

}
