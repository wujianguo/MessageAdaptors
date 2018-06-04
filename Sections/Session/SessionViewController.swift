//
//  SessionViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import MessageKit

class SessionViewController<AccountType: MessageAccount>: MessagesViewController {

    let account: AccountType
    var session: AccountType.SessionType
    
    init(account: AccountType, session: AccountType.SessionType) {
        self.account = account
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let refreshControl = UIRefreshControl()
    var firstWillAppear = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = session.displayName
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage, style: .plain, target: self, action: #selector(userItemClick(sender:)))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        session.add(consumer: self)
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages(sender:)), for: .valueChanged)
        
        firstLoad()
    }
    
    var rightBarButtonImage: UIImage? {
        switch session.sessionType {
        case .P2P:
            return Images.User
        default:
            return Images.Group
        }
    }

    deinit {
        session.remove(consumer: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstWillAppear {
            firstWillAppear = false
            messagesCollectionView.scrollToBottom()
        }
    }

    // MARK: - Navigation

    @objc func userItemClick(sender: UIBarButtonItem) {
        let vc = UserTableViewController<AccountType>(account: account, user: session.user)
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Load more messages
    
    func firstLoad() {
        if session.messages.count > 20 {
            return
        }
        let msgs = session.fetchLocalHistory()
        if msgs.count > 0 {
            return
        }
    }
    
    @objc func loadMoreMessages(sender: UIRefreshControl) {
        sender.endRefreshing()
    }
}


// MARK: - MessageConsumer

extension SessionViewController: MessageConsumer {

    func on(sessionId: String, recv messages: [MessageObject]) {        
        let start = session.messages.count - messages.count
        let end = session.messages.count
        let index = IndexSet(integersIn: start..<end)
        messagesCollectionView.insertSections(index)
        messagesCollectionView.scrollToBottom()
    }

}

// MARK: - MessagesDataSource

extension SessionViewController: MessagesDataSource {
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return session.messages.count
    }
    
    func currentSender() -> Sender {
        return account.sender()
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return session.messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        }
        return nil
    }

    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if session.sessionType != .P2P {
            let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
        } else {
            return nil
        }
    }

}

extension SessionViewController: MessagesDisplayDelegate {
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = session.messages[indexPath.section]
        avatarView.kf.setImage(with: message.user.avatarURL)
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let item):
            imageView.kf.setImage(with: item.url)
        default:
            break
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

extension SessionViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 {
            return 10
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if session.sessionType != .P2P {
            return 16
        } else {
            return 0
        }
    }

}

// MARK: - MessageCellDelegate
extension SessionViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            let vc = UserTableViewController<AccountType>(account: account, user: session.messages[indexPath.section].user)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
}

// MARK: - MessageLabelDelegate
extension SessionViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
}

// MARK: - MessageInputBarDelegate

extension SessionViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Each NSTextAttachment that contains an image will count as one empty character in the text: String
        
        for component in inputBar.inputTextView.components {
            
            if let text = component as? String {
                let message = AccountType.ObjectType(kind: .text(text), sender: account)
                account.send(message: message, to: session)
                messagesCollectionView.insertSections([session.messages.count - 1])
            }
            
        }
        
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()

    }
}
