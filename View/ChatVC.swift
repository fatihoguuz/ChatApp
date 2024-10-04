//
//  ViewController.swift
//  ChatApp
//
//  Created by Fatih Oğuz on 14.09.2024.
//

import UIKit
import FirebaseAuth
import Combine

class ChatVC: UIViewController {
    
    //MARK: - UIComponents
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.returnKeyType = .default
        textView.textContainerInset = UIEdgeInsets(top: 9, left: 9, bottom: 10, right: 30)
        textView.backgroundColor = .gray
        textView.layer.cornerRadius = 35
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()
    
    lazy var sendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "paperplane")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSend))
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    var messages = [Message]()
    var tokens: Set<AnyCancellable> = []
    var currentUser : User!
    init(currentUser: User) {
        self .currentUser = currentUser
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        constraints()
        subscribeToKeyboardShowHide()
        setupNavBar()
        fetchMessages()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(textView)
        view.addSubview(sendImageView)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK: - Constraints
    private func constraints() {
        NSLayoutConstraint.activate([
            // TableView Constraints
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),
            
            // TextView Constraints
            textView.topAnchor.constraint(equalTo: tableView.bottomAnchor,constant: -110),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -40),
                        
            // TableView Constraints
            sendImageView.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
            sendImageView.trailingAnchor.constraint(equalTo: textView.trailingAnchor,constant: -5),
            sendImageView.heightAnchor.constraint(equalToConstant: 80),
            sendImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc private func didTapSend() {
        if let textMessage = textView.text, textMessage.count > 2 {
            let msg = Message(text: textMessage, photoURL: currentUser.photoURL?.absoluteString ?? "", uid: currentUser.uid, cratedAt: Date())
            DatabaseManager.shared.sendMessageToDatabase(message: msg)
            messages.append(msg)
            textView.text = ""
            tableView.reloadData()
            let index = IndexPath(row: messages.count-1, section: 0)
            tableView.scrollToRow(at: index, at: .bottom, animated: true)
        }
    }
    @objc func setupNavBar() {
        navigationController?.navigationBar.topItem?.title = "ChatApp"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(didTapSignOut))
        navigationController?.navigationBar.tintColor = .red
    }

    @objc func didTapSignOut() {
        
        do{
            try AuthManager.shared.signOut()
            let signInVC = UINavigationController(rootViewController: SignInVC())
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc: signInVC)
        }catch{
            print("Error singing out ")
        }
    }
    
    // MARK: Keyboard Events
    private func subscribeToKeyboardShowHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification){
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.view.frame.origin.y = -keyboardFrame.size.height
    }
    @objc func keyboardWillHide(notification: Notification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.view.frame.origin.y = 0
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    // MARK: Fetch Messages
    private func fetchMessages() {
        Task{
            let msgs = try await DatabaseManager.shared.fetchAllMessages()
            self.messages = msgs
            await MainActor.run(body: {
                self.tableView.reloadData()
            })
        }
    }
       private func subscribeToMessagePublisher() {
           DatabaseManager.shared.updatedMessagesPublisher.receive(on: DispatchQueue.main).sink { _ in
               
           } receiveValue: { messages in
               self.messages = messages
               self.tableView.reloadData()
           }.store(in: &tokens)
    }
}

extension ChatVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as? ChatCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
//        if index % 2 == 0 {
//            cell.configureForMessage(message: messages[index], isUser: true)
//        } else{
//            cell.configureForMessage(message: messages[index], isUser: false)
//        }
        cell.configureForMessage(message: messages[index], currentId: currentUser.uid)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
extension ChatVC: UITextViewDelegate {
  
}
