//
//  AddOverviewController.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/4/23.
//

import UIKit
import FirebaseFirestore

class AddOverviewController: UIViewController {
    
    var roomCode: String?
    weak var delegate: AddOverviewDelegate?
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Start Date"
        label.numberOfLines = 1
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "End Date"
        label.numberOfLines = 1
        return label
    }()
    
    private let locationField = CustomTextField(fieldType: .location)
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private let submitButton = CustomButton(title: "Submit", hasBackground: true, fontSize: .med)
    
    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(locationField)
        self.view.addSubview(startDateLabel)
        self.view.addSubview(startDatePicker)
        self.view.addSubview(endDateLabel)
        self.view.addSubview(endDatePicker)
        self.view.addSubview(submitButton)
        
        locationField.translatesAutoresizingMaskIntoConstraints = false
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.locationField.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.locationField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.locationField.heightAnchor.constraint(equalToConstant: 55),
            self.locationField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.startDateLabel.topAnchor.constraint(equalTo: locationField.bottomAnchor, constant: 20),
            self.startDateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.startDatePicker.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 16),
            self.startDatePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.endDateLabel.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 20),
            self.endDateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.endDatePicker.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 16),
            self.endDatePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.submitButton.topAnchor.constraint(equalTo: self.endDatePicker.bottomAnchor, constant: 16),
            self.submitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.submitButton.heightAnchor.constraint(equalToConstant: 55),
            self.submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.50),
        ])
        
        startDatePicker.datePickerMode = .date
        endDatePicker.datePickerMode = .date
    }
    
    @objc private func didTapSubmit() {
        guard let location = locationField.text, let roomCode = roomCode else {
            return
        }

        let startDate = startDatePicker.date
        let endDate = endDatePicker.date

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)

        let locationData: [String: Any] = [
            "location": location,
        ]

        let dateData: [String: Any] = [
            "startDate": startDateString,
            "endDate": endDateString
        ]

        let locationDocumentPath = "Room/\(roomCode)/generalInfo/location"
        let dateDocumentPath = "Room/\(roomCode)/generalInfo/dateRange"

        db.document(locationDocumentPath).setData(locationData)
        db.document(dateDocumentPath).setData(dateData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
                if let delegate = self.delegate {
                    delegate.didSubmitOverviewFormWith(location: location, startDate: startDateString, endDate: endDateString)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

protocol AddOverviewDelegate: AnyObject {
    func didSubmitOverviewFormWith(location: String, startDate: String, endDate: String)
}
