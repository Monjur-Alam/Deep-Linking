//
//  SettingsViewController.swift
//  Deep Linking
//
//  Created by MunjurAlam on 11/2/25.
//


import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Settings Screen"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let darkModeSwitch = UISwitch()
        darkModeSwitch.isOn = false
        darkModeSwitch.addTarget(self, action: #selector(darkModeToggled(_:)), for: .valueChanged)
        darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        let darkModeLabel = UILabel()
        darkModeLabel.text = "Enable Dark Mode"
        darkModeLabel.font = UIFont.systemFont(ofSize: 18)
        darkModeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [darkModeLabel, darkModeSwitch])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func darkModeToggled(_ sender: UISwitch) {
        if sender.isOn {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
    }
}