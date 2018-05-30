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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = session.displayName
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.User, style: .plain, target: self, action: #selector(userItemClick(sender:)))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        session.add(consumer: self)
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages(sender:)), for: .valueChanged)
        
        firstLoad()
        messagesCollectionView.scrollToBottom()
    }

    deinit {
        session.remove(consumer: self)
    }
    

    // MARK: - Navigation

    @objc func userItemClick(sender: UIBarButtonItem) {
        let vc = UserTableViewController<AccountType>(account: account, user: session.user)
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Load more messages
    
    func firstLoad() {
        if session.messages.count > 0 {
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
}

extension SessionViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 200
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = session.messages[indexPath.section]
        avatarView.kf.setImage(with: message.user.avatarURL)
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
