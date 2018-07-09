//
//  SessionViewController.swift
//  NeteaseIM
//
//  Created by Jianguo Wu on 2018/5/7.
//  Copyright © 2018年 wujianguo. All rights reserved.
//

import UIKit
import SafariServices
import MessageKit
import AVKit

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
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: MessageCustomMessagesFlowLayout())
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = session.displayName
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.More, style: .plain, target: self, action: #selector(userItemClick(sender:)))
        
        MessageCustomLayoutManager.register(at:messagesCollectionView)

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
    
    // MARK: - Custom Message
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = session.messages[indexPath.section]
        if let object = message.kind.custom as? MessageCustomObject {
            if let cell = MessageCustomLayoutManager.dequeueReusableCell(at: collectionView, for: indexPath, with: object) {
                return cell
            }
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
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
    
    func shouldShowTime(at indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }
        return abs(session.messages[indexPath.section].sentDate.timeIntervalSince1970 - session.messages[indexPath.section-1].sentDate.timeIntervalSince1970) > 300
    }
    
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
        if shouldShowTime(at: indexPath) {
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
        if shouldShowTime(at: indexPath) {
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
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            switch session.messages[indexPath.section].kind {
            case .video(let item):
                if let url = item.url {
                    let vc = AVPlayerViewController()
                    vc.player = AVPlayer(url: url)
                    vc.player?.play()
                    present(vc, animated: true, completion: nil)
                }
            default:
                break
            }
        }
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
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
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

extension SessionViewController: SplitDetailProtocol {
    var isDetail: Bool {
        return true
    }
}


class MessageCustomSizeCalculator: MessageSizeCalculator {

//    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }

}

class MessageCustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    
    lazy open var customMessageSizeCalculator = MessageCustomSizeCalculator(layout: self)
    
    override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if let object = message.kind.custom as? MessageCustomObject {
            return customMessageSizeCalculator
//            if let calculator = MessageCustomLayoutManager.cellSizeCalculator(for: object) {
//                return calculator
//            }
        }
        return super.cellSizeCalculatorForItem(at: indexPath)
    }
}
