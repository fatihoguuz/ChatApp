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
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let messageImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chat")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor // Gölgenin rengi
        imageView.layer.shadowOpacity = 0.3 // Gölgenin opaklığı (0.0 - 1.0)
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4) // Gölgenin kaydırma miktarı
        imageView.layer.shadowRadius = 8 // Gölgenin yayılma yarıçapı
        return imageView
    }()
    private let answerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .opaqueSeparator
        view.layer.shadowColor = UIColor.black.cgColor // Gölgenin rengi
        view.layer.shadowOpacity = 0.3 // Gölgenin opaklığı (0.0 - 1.0)
        view.layer.shadowOffset = CGSize(width: 0, height: 4) // Gölgenin kaydırma miktarı
        view.layer.shadowRadius = 8 // Gölgenin yayılma yarıçapı
        return view
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.text = "Lütfen Giriş Yapınız."
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let answerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chat2")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor // Gölgenin rengi
        imageView.layer.shadowOpacity = 0.3 // Gölgenin opaklığı (0.0 - 1.0)
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4) // Gölgenin kaydırma miktarı
        imageView.layer.shadowRadius = 8 // Gölgenin yayılma yarıçapı
        return imageView
    }()
    
    let googleButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        configureButton()
        configureGoogleSignIn()
    }
    
    private func configureButton() {
        view.addSubview(googleButton)
        view.addSubview(messageView)
        view.addSubview(messageLabel)
        view.addSubview(messageImage)
        view.addSubview(answerView)
        view.addSubview(answerLabel)
        view.addSubview(answerImage)
       
        view.backgroundColor = .systemBackground
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.addTarget(self, action: #selector(didTapGoogleSignIn), for: .touchUpInside)
        
        let screenHeight = UIScreen.main.bounds.height
        let topPadding = screenHeight * 0.2
        NSLayoutConstraint.activate([
            
            messageView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            messageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 12),
            messageView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            
            messageLabel.trailingAnchor.constraint(equalTo: messageImage.leadingAnchor, constant: -25),
            messageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding),
            messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15),
    
            messageImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            messageImage.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            messageImage.heightAnchor.constraint(equalToConstant: 50),
            messageImage.widthAnchor.constraint(equalToConstant: 50),
            
            answerLabel.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 40),
            answerLabel.leadingAnchor.constraint(equalTo: answerImage.trailingAnchor, constant: 25),
            answerLabel.trailingAnchor.constraint(equalTo: answerView.trailingAnchor, constant: -10),
            
            answerView.topAnchor.constraint(equalTo: answerLabel.topAnchor, constant: -8),
            answerView.leadingAnchor.constraint(equalTo: answerLabel.leadingAnchor, constant: -12),
            answerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            answerView.bottomAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 8),
            
            answerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            answerImage.centerYAnchor.constraint(equalTo: answerView.centerYAnchor),
            answerImage.heightAnchor.constraint(equalToConstant: 50),
            answerImage.widthAnchor.constraint(equalToConstant: 50),
            
            googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleButton.widthAnchor.constraint(equalToConstant: 350),
            googleButton.topAnchor.constraint(equalTo: answerView.bottomAnchor, constant: 150),
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
