//
//  CustomTextField.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/3/23.
//

import UIKit

class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case username
        case password
        case email
        case roomCode
        case location
        case hotelName
        case hotelAddress
        case airline
        case airport
    }
    
    private let authFieldType: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .username:
            self.placeholder = "Username"
        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        case .email:
            self.placeholder = "Email Address"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .roomCode:
            self.placeholder = "Room Code"
        case .location:
            self.placeholder = "Enter your trip destination"
        case .hotelName:
            self.placeholder = "Enter the hotel name"
        case .hotelAddress:
            self.placeholder = "Enter the hotel address"
        case .airline:
            self.placeholder = "Enter the airline"
        case .airport:
            self.placeholder = "Enter the airport"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
