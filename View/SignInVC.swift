//
//  SignInVC.swift
//  ChatApp
//
//  Created by Fatih Oğuz on 29.09.2024.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

let greenColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)

class SignInVC: UIViewController {
    
    
    private let messageView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = greenColor
        view.layer.shadowColor = UIColor.black.cgColor // Gölgenin rengi
        view.layer.shadowOpacity = 0.3 // Gölgenin opaklığı (0.0 - 1.0)
        view.layer.shadowOffset = CGSize(width: 0, height: 4) // Gölgenin kaydırma miktarı
        view.layer.shadowRadius = 8 // Gölgenin yayılma yarıçapı
        return view
    }()
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat App' e Hoş Geldiniz"
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let googlebButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        configureButton()
        configureGoogleSignIn()
    }
    
    private func configureButton() {
        view.addSubview(googlebButton)
        view.addSubview(messageView)
        view.addSubview(messageLabel)
        view.backgroundColor = .systemBackground
        googlebButton.translatesAutoresizingMaskIntoConstraints = false
        googlebButton.addTarget(self, action: #selector(didTapGoogleSignIn), for: .touchUpInside)
        
        let screenHeight = UIScreen.main.bounds.height
        let topPadding = screenHeight * 0.15
        NSLayoutConstraint.activate([
            messageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            messageView.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding),
            messageView.heightAnchor.constraint(equalToConstant: 120),
            
            messageLabel.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -10),
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 10),
            //messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 10),
            
            googlebButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googlebButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func configureGoogleSignIn() {
       let clientID = "667523744794-r6shjqkc4nvg90gnrl02r69p5rjo6ngi.apps.googleusercontent.com"

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    @objc private func didTapGoogleSignIn() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {[weak self] result, error in
            guard let user = result?.user,
              let idToken = user.idToken?.tokenString,
            let strongSelf = self else {
                print("errorw")
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            AuthManager.shared.signIn(cred: credential)
        }
    }
}
