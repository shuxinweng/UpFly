//
//  ReturningFlightViewController.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/7/23.
//

import UIKit
import FirebaseFirestore

class ReturningFlightViewController: UIViewController {
    
    var roomCode: String?
    weak var delegate: ReturningFlightDelegate?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Returning Date&Time"
        label.numberOfLines = 1
        return label
    }()
    
    private let airlineField = CustomTextField(fieldType: .airline)
    private let airportField = CustomTextField(fieldType: .airport)
    private let dateTimePicker = UIDatePicker()
    
    private let submitButton = CustomButton(title: "Submit", hasBackground: true, fontSize: .med)
    
    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(airlineField)
        self.view.addSubview(airportField)
        self.view.addSubview(dateLabel)
        self.view.addSubview(dateTimePicker)
        self.view.addSubview(submitButton)
        
        airlineField.translatesAutoresizingMaskIntoConstraints = false
        airportField.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTimePicker.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.airlineField.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.airlineField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.airlineField.heightAnchor.constraint(equalToConstant: 55),
            self.airlineField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.airportField.topAnchor.constraint(equalTo: self.airlineField.bottomAnchor, constant: 16),
            self.airportField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.airportField.heightAnchor.constraint(equalToConstant: 55),
            self.airportField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.dateLabel.topAnchor.constraint(equalTo: airportField.bottomAnchor, constant: 20),
            self.dateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.dateTimePicker.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 16),
            self.dateTimePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.submitButton.topAnchor.constraint(equalTo: self.dateTimePicker.bottomAnchor, constant: 16),
            self.submitButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.submitButton.heightAnchor.constraint(equalToConstant: 55),
            self.submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.50),
        ])
        
        dateTimePicker.datePickerMode = .dateAndTime
    }
    
    @objc private func didTapSubmit() {
        guard let airline = airlineField.text, let airport = airportField.text, let roomCode = roomCode else {
            return
        }

        let returnDateTime = dateTimePicker.date

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let returnDateTimeString = dateFormatter.string(from: returnDateTime)

        let flightData: [String: Any] = [
            "airline": airline,
            "airport": airport,
            "returnDateTime": returnDateTimeString
        ]

        let flightDocumentPath = "Room/\(roomCode)/flightInfo/returningFlight"

        db.document(flightDocumentPath).setData(flightData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
                if let delegate = self.delegate {
                    delegate.didSubmitReturningFlightInfo(airline: airline, airport: airport, returnDateTime: returnDateTimeString)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

protocol ReturningFlightDelegate: AnyObject {
    func didSubmitReturningFlightInfo(airline: String, airport: String, returnDateTime: String)
}
