//
//  ChatCell.swift
//  ChatApp
//
//  Created by Fatih Oğuz on 18.09.2024.
//

import UIKit
import SDWebImage

class ChatCell: UITableViewCell {
    
    let greenColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
    
    static let identifier = "ChatCell"
    //MARK: - UIComponents
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .white
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 15
        return view
    }()
    
    let chatTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "test"
        label.textColor = .white
       
        return label
    }()
    
    var textLeading: NSLayoutConstraint!
    var textTrailing: NSLayoutConstraint!
    
    var imageLeading: NSLayoutConstraint!
    var imageTrailing: NSLayoutConstraint!
    //MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - SetupUI
    private func setupUI() {
        
         addSubview(profileImageView)
         addSubview(bubbleView)
         addSubview(chatTextLabel)
    }
    //MARK: - Constraints
    private func configure() {
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            profileImageView.widthAnchor.constraint(equalToConstant: 32),
            
            chatTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            chatTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            chatTextLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 260),
            
            bubbleView.topAnchor.constraint(equalTo: chatTextLabel.topAnchor, constant: -8),
            bubbleView.leadingAnchor.constraint(equalTo: chatTextLabel.leadingAnchor, constant: -12),
            bubbleView.trailingAnchor.constraint(equalTo: chatTextLabel.trailingAnchor, constant: 12),
            bubbleView.bottomAnchor.constraint(equalTo: chatTextLabel.bottomAnchor, constant: 8),
        ])
        
        imageLeading = profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        imageTrailing = profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        
        textLeading = chatTextLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20)
        textTrailing = chatTextLabel.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -20)
        
    }
    
    func configureForMessage(message: Message, currentId: String) {
        let isUser = currentId == message.uid ? true : false
        chatTextLabel.text = message.text
        
        if message.photoURL.count > 0 {
            let url = URL(string: message.photoURL)
            profileImageView.sd_setImage(with: url)
        }
        if isUser {
            bubbleView.backgroundColor = greenColor
            imageTrailing.isActive = true
            textTrailing.isActive = true
            
            imageLeading.isActive = false
            textLeading.isActive = false
            
        }else{
            bubbleView.backgroundColor = .opaqueSeparator
            imageLeading.isActive = true
            textLeading.isActive = true
            
            imageTrailing.isActive = false
            textTrailing.isActive = false
        }
    }
    func configureForMock(message: String, isUser: Bool) {
        chatTextLabel.text = message
        if isUser {
            bubbleView.backgroundColor = greenColor
            imageTrailing.isActive = true
            textTrailing.isActive = true
            
            imageLeading.isActive = false
            textLeading.isActive = false
            
        }else{
            bubbleView.backgroundColor = .opaqueSeparator
            imageLeading.isActive = true
            textLeading.isActive = true
            
            imageTrailing.isActive = false
            textTrailing.isActive = false
        }
    }
}
