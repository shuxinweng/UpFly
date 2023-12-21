//
//  HomeController.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/2/23.
//

import UIKit

class RoomController: UIViewController {

    enum AppearanceMode: String {
        case light, dark

        var userDefaultsKey: String {
            return "com.yourapp.appearanceMode"
        }
    }

    private let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.text = "Loading..."
        label.numberOfLines = 2
        return label
    }()

    private let roomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Room Code"
        label.numberOfLines = 1
        return label
    }()

    private let quotesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.text = "Quotes loading..."
        return label
    }()

    private let roomField = CustomTextField(fieldType: .roomCode)

    private let roomButton = CustomButton(title: "Join/Create Room", hasBackground: true, fontSize: .small)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.loadAppearanceMode()
        
        self.roomButton.addTarget(self, action: #selector(didTapRoom), for: .touchUpInside)
        
        updateAppearance((UIApplication.shared.delegate as? AppDelegate)?.appearanceMode ?? .light)
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            }
            
            if let user = user {
                self.userLabel.text = "\(user.username)\n\(user.email)"
            }
            
            self.addDarkModeToggleButton()
            
            self.getQuotes()
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))

        self.view.addSubview(userLabel)
        self.view.addSubview(roomLabel)
        self.view.addSubview(roomField)
        self.view.addSubview(roomButton)
        self.view.addSubview(quotesLabel)

        userLabel.translatesAutoresizingMaskIntoConstraints = false
        roomLabel.translatesAutoresizingMaskIntoConstraints = false
        roomField.translatesAutoresizingMaskIntoConstraints = false
        roomButton.translatesAutoresizingMaskIntoConstraints = false
        quotesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.userLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.userLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),

            self.roomLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 100),
            self.roomLabel.centerXAnchor.constraint(equalTo: userLabel.centerXAnchor),

            self.roomField.topAnchor.constraint(equalTo: roomLabel.bottomAnchor, constant: 20),
            self.roomField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.roomField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.roomField.heightAnchor.constraint(equalToConstant: 55),
            self.roomField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),

            self.roomButton.topAnchor.constraint(equalTo: roomField.bottomAnchor, constant: 22),
            self.roomButton.centerXAnchor.constraint(equalTo: userLabel.centerXAnchor),
            self.roomButton.heightAnchor.constraint(equalToConstant: 55),
            self.roomButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.50),

            self.quotesLabel.topAnchor.constraint(equalTo: roomButton.bottomAnchor, constant: 50),
            self.quotesLabel.centerXAnchor.constraint(equalTo: userLabel.centerXAnchor),
            self.quotesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
        ])
    }

    private func loadAppearanceMode() {
        if let modeString = UserDefaults.standard.string(forKey: AppearanceMode.light.userDefaultsKey),
           let mode = AppearanceMode(rawValue: modeString) {
            updateAppearance(mode)
        }
    }

    private func updateAppearance(_ mode: AppearanceMode) {
        switch mode {
        case .light:
            overrideUserInterfaceStyle = .light
        case .dark:
            overrideUserInterfaceStyle = .dark
        }
    }

    private func toggleAppearanceMode() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let currentMode = UserDefaults.standard.string(forKey: AppearanceMode.light.userDefaultsKey)
        let newMode = (currentMode == AppearanceMode.light.rawValue) ? AppearanceMode.dark : AppearanceMode.light
        UserDefaults.standard.set(newMode.rawValue, forKey: AppearanceMode.light.userDefaultsKey)
        updateAppearance(newMode)

        appDelegate?.appearanceMode = newMode
    }
    
    @objc private func didTapDarkModeToggle() {
        toggleAppearanceMode()
    }

    private func addDarkModeToggleButton() {
        let darkModeToggleButton = UIButton(type: .system)
        darkModeToggleButton.setTitle("Switch Dark/Light Mode", for: .normal)
        darkModeToggleButton.addTarget(self, action: #selector(didTapDarkModeToggle), for: .touchUpInside)

        view.addSubview(darkModeToggleButton)
        darkModeToggleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            darkModeToggleButton.topAnchor.constraint(equalTo: quotesLabel.bottomAnchor, constant: 20),
            darkModeToggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showLogoutError(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
    @objc private func didTapRoom() {
        guard let roomCode = roomField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !roomCode.isEmpty else {
            AlertManager.showInvaildRoomCode(on: self)
            return
        }
        
        FirebaseService.shared.checkRoomExists(roomCode: roomCode) { [weak self] exists in
            guard let self = self else { return }
            
            if exists {
                self.joinRoom(with: roomCode)
            } else {
                self.createRoom(with: roomCode)
            }
        }
    }
    
    private func joinRoom(with roomCode: String) {
        let vc = TabBarController()
        vc.roomCode = roomCode
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func createRoom(with roomCode: String) {
        FirebaseService.shared.createRoom(roomCode: roomCode)
        let vc = TabBarController()
        vc.roomCode = roomCode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getQuotes() {
        let category = "happiness".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "https://api.api-ninjas.com/v1/quotes?category="+category!)!
        var request = URLRequest(url: url)
        request.setValue("Z0m5Yo+kPUIstt3+xmFHVQ==yH00tWaII1EH5pdk", forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let data = data {
                do {
                    let quotes = try JSONDecoder().decode([Quote].self, from: data)
                    DispatchQueue.main.async {
                        self.updateQuotesUI(quotes)
                    }
                } catch {
                    print("Error decoding quotes: \(error)")
                }
            }
        }
        task.resume()
    }

    private func updateQuotesUI(_ quotes: [Quote]) {
        if let oneQoute = quotes.first {
            let quoteText = "\"\(oneQoute.quote)\" - Author: \(oneQoute.author) - Category: \(oneQoute.category)"
            self.quotesLabel.text = quoteText
        }
    }
}

struct Quote: Codable {
    let quote: String
    let author: String
    let category: String
}
