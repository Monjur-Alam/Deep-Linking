//
//  ViewController.swift
//  Deep Linking
//
//  Created by MunjurAlam on 11/2/25.
//

import UIKit

import UIKit

class ProfileViewController: UIViewController {
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "https://zunayedarifin.com/profile"
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.isUserInteractionEnabled = true // Enable interaction
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Profile"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(systemName: "person.circle")
        profileImageView.tintColor = .gray
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = "John Doe"
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(profileImageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            label.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(copyText))
        label.addGestureRecognizer(longPress)
    }
    
    @objc func copyText(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let menu = UIMenuController.shared
            if !menu.isMenuVisible {
                becomeFirstResponder()
                menu.showMenu(from: label, rect: label.bounds)
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = label.text
    }
}


