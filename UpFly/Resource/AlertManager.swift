//
//  AlertManager.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/3/23.
//

import UIKit

class AlertManager {
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

// MARK: - Validation Alerts
extension AlertManager {
    public static func showInvaildEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invaild Email", message: "Please enter a vaild email.")
    }
    
    public static func showInvaildPasswordAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invaild Password", message: "Please enter a vaild password.")
    }
    
    public static func showInvaildUsernameAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invaild Username", message: "Please enter a vaild username.")
    }
}

// MARK: - Registration Error
extension AlertManager {
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknown Registration Error", message: nil)
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Unknown Registration Error", message: "\(error.localizedDescription)")
    }
}

// MARK: - Login Error
extension AlertManager {
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknown Error Signing In", message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error Signing In", message: "\(error.localizedDescription)")
    }
}

// MARK: - Logout Error
extension AlertManager {
    public static func showLogoutError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Unknown Error Logging Out", message: "\(error.localizedDescription)")
    }
}

// MARK: - Forgot Password Error
extension AlertManager {
    public static func showPasswordResetSent(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Password Reset Sent", message: nil)
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error Sending Password Reset", message: "\(error.localizedDescription)")
    }
}

// MARK: - Fetching User Error
extension AlertManager {
    public static func showFetchingUserError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error Fetching User", message: "\(error.localizedDescription)")
    }
    
    public static func showUnknownFetchingUserError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknown Error Fetching User", message: nil)
    }
}

// MARK: - Room Code
extension AlertManager {
    public static func showInvaildRoomCode(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Room Code can not be empty", message: nil)
    }
}
