//
//  HotelViewController.swift
//  UpFly
//
//  Created by Shuxin Weng on 11/27/23.
//

import UIKit
import FirebaseFirestore

class HotelViewController: UIViewController {
    
    var roomCode: String?
    weak var delegate: HotelDelegate?
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Stay Start Date"
        label.numberOfLines = 1
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Stay End Date"
        label.numberOfLines = 1
        return label
    }()
    
    private let hotelNameField = CustomTextField(fieldType: .hotelName)
    private let hotelAddressField = CustomTextField(fieldType: .hotelAddress)
    private let stayingStartDatePicker = UIDatePicker()
    private let stayingEndDatePicker = UIDatePicker()
    
    private let submitButton = CustomButton(title: "Submit", hasBackground: true, fontSize: .med)
    
    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(hotelNameField)
        self.view.addSubview(hotelAddressField)
        self.view.addSubview(startDateLabel)
        self.view.addSubview(stayingStartDatePicker)
        self.view.addSubview(endDateLabel)
        self.view.addSubview(stayingEndDatePicker)
        self.view.addSubview(submitButton)
        
        hotelNameField.translatesAutoresizingMaskIntoConstraints = false
        hotelAddressField.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        stayingStartDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        stayingEndDatePicker.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.hotelNameField.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.hotelNameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.hotelNameField.heightAnchor.constraint(equalToConstant: 55),
            self.hotelNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.hotelAddressField.topAnchor.constraint(equalTo: self.hotelNameField.bottomAnchor, constant: 16),
            self.hotelAddressField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.hotelAddressField.heightAnchor.constraint(equalToConstant: 55),
            self.hotelAddressField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.startDateLabel.topAnchor.constraint(equalTo: hotelAddressField.bottomAnchor, constant: 20),
            self.startDateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.stayingStartDatePicker.topAnchor.constraint(equalTo: self.startDateLabel.bottomAnchor, constant: 16),
            self.stayingStartDatePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.endDateLabel.topAnchor.constraint(equalTo: stayingStartDatePicker.bottomAnchor, constant: 20),
            self.endDateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.stayingEndDatePicker.topAnchor.constraint(equalTo: self.endDateLabel.bottomAnchor, constant: 16),
            self.stayingEndDatePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.submitButton.topAnchor.constraint(equalTo: self.stayingEndDatePicker.bottomAnchor, constant: 16),
            self.submitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.submitButton.heightAnchor.constraint(equalToConstant: 55),
            self.submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.50),
        ])
        
        stayingStartDatePicker.datePickerMode = .date
        stayingEndDatePicker.datePickerMode = .date
    }
    
    @objc private func didTapSubmit() {
        guard let hotelName = hotelNameField.text, let hotelAddress = hotelAddressField.text, let roomCode = roomCode else {
            return
        }

        let startDate = stayingStartDatePicker.date
        let endDate = stayingEndDatePicker.date

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)

        let hotelData: [String: Any] = [
            "hotelName": hotelName,
            "hotelAddress": hotelAddress
        ]

        let dateData: [String: Any] = [
            "startDate": startDateString,
            "endDate": endDateString
        ]

        let hotelDocumentPath = "Room/\(roomCode)/hotelInfo/hotelData"
        let dateDocumentPath = "Room/\(roomCode)/hotelInfo/stayTime"

        db.document(hotelDocumentPath).setData(hotelData)
        db.document(dateDocumentPath).setData(dateData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
                if let delegate = self.delegate {
                    delegate.didSubmitHotelFormWith(hotelName: hotelName, hotelAddress: hotelAddress, startDate: startDateString, endDate: endDateString)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

protocol HotelDelegate: AnyObject {
    func didSubmitHotelFormWith(hotelName: String, hotelAddress: String, startDate: String, endDate: String)
}
