//
//  RoomController.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/4/23.
//

import UIKit
import FirebaseFirestore

class OverviewController: UIViewController, AddOverviewDelegate, HotelDelegate, DepartingFlightDelegate, ReturningFlightDelegate {
    
    private var roomCode: String?

    private let roomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Room Label"
        label.numberOfLines = 1
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Not destination set up yet"
        label.numberOfLines = 5
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Date range set up yet"
        label.numberOfLines = 2
        return label
    }()
    
    private let departingAirlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Departing Flight Info yet"
        label.numberOfLines = 1
        return label
    }()
    
    private let departingAirportLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Departing Flight Info yet"
        label.numberOfLines = 1
        return label
    }()
    
    private let departingDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Departing Flight Info yet"
        label.numberOfLines = 1
        return label
    }()

    private let returningAirlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Returning Flight Info yet"
        label.numberOfLines = 1
        return label
    }()
    
    private let returningAirportLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Returning Flight Info yet"
        label.numberOfLines = 1
        return label
    }()
    
    private let returningDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Returning Flight Info yet"
        label.numberOfLines = 1
        return label
    }()

    private let hotelNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Hotel Info yet"
        label.numberOfLines = 1
        return label
    }()
    
    private let hotelAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Hotel Address set yet"
        label.numberOfLines = 2
        return label
    }()
    
    private let stayTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "No Stay Time set yet"
        label.numberOfLines = 2
        return label
    }()

    
    private let weatherButton = CustomButton(title: "Weather Info", fontSize: .small)
    private let departingFlightButton = CustomButton(title: "Edit Departing Flight Info", fontSize: .small)
    private let returningFlightButton = CustomButton(title: "Edit Returning Flight Info", fontSize: .small)
    private let hotelButton = CustomButton(title: "Edit Hotel Info", fontSize: .small)

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = self.tabBarController as? TabBarController {
            let roomCode = tabBarController.roomCode
            self.roomLabel.text = roomCode
            fetchDataFromFirebase(roomCode: roomCode)
        }
        self.setupUI()
        
        self.weatherButton.addTarget(self, action: #selector(didTapWeather), for: .touchUpInside)
        self.departingFlightButton.addTarget(self, action: #selector(didTapDepartingFlight), for: .touchUpInside)
        self.returningFlightButton.addTarget(self, action: #selector(didTapReturningFlight), for: .touchUpInside)
        self.hotelButton.addTarget(self, action: #selector(didTapHotel), for: .touchUpInside)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        // Room
        self.view.addSubview(roomLabel)
        // General Info
        self.view.addSubview(locationLabel)
        self.view.addSubview(dateLabel)
        // Weather
        self.view.addSubview(weatherButton)
        // Flight
        self.view.addSubview(departingAirlineLabel)
        self.view.addSubview(departingAirportLabel)
        self.view.addSubview(departingDateLabel)
        self.view.addSubview(departingFlightButton)
        self.view.addSubview(returningAirlineLabel)
        self.view.addSubview(returningAirportLabel)
        self.view.addSubview(returningDateLabel)
        self.view.addSubview(returningFlightButton)
        // Hotel
        self.view.addSubview(hotelNameLabel)
        self.view.addSubview(hotelAddressLabel)
        self.view.addSubview(stayTimeLabel)
        self.view.addSubview(hotelButton)
        
        // Room
        roomLabel.translatesAutoresizingMaskIntoConstraints = false
        // General Info
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        // Weather
        weatherButton.translatesAutoresizingMaskIntoConstraints = false
        // Flight
        departingAirlineLabel.translatesAutoresizingMaskIntoConstraints = false
        departingAirportLabel.translatesAutoresizingMaskIntoConstraints = false
        departingDateLabel.translatesAutoresizingMaskIntoConstraints = false
        departingFlightButton.translatesAutoresizingMaskIntoConstraints = false
        returningAirlineLabel.translatesAutoresizingMaskIntoConstraints = false
        returningAirportLabel.translatesAutoresizingMaskIntoConstraints = false
        returningDateLabel.translatesAutoresizingMaskIntoConstraints = false
        returningFlightButton.translatesAutoresizingMaskIntoConstraints = false
        // Hotel
        hotelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        hotelAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        stayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        hotelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Room
            self.roomLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.roomLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            // General Info
            self.locationLabel.topAnchor.constraint(equalTo: roomLabel.topAnchor, constant: 20),
            self.locationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.dateLabel.topAnchor.constraint(equalTo: locationLabel.topAnchor, constant: 20),
            self.dateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            // Weather
            self.weatherButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            self.weatherButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.weatherButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.50),
            
            // Flight
            self.departingAirlineLabel.topAnchor.constraint(equalTo: weatherButton.topAnchor, constant: 75),
            self.departingAirlineLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.departingAirportLabel.topAnchor.constraint(equalTo: departingAirlineLabel.topAnchor, constant: 20),
            self.departingAirportLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.departingDateLabel.topAnchor.constraint(equalTo: departingAirportLabel.topAnchor, constant: 20),
            self.departingDateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.departingFlightButton.topAnchor.constraint(equalTo: departingDateLabel.bottomAnchor, constant: 11),
            self.departingFlightButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.departingFlightButton.heightAnchor.constraint(equalToConstant: 55),
            self.departingFlightButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.50),
            
            self.returningAirlineLabel.topAnchor.constraint(equalTo: departingFlightButton.topAnchor, constant: 75),
            self.returningAirlineLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.returningAirportLabel.topAnchor.constraint(equalTo: returningAirlineLabel.topAnchor, constant: 20),
            self.returningAirportLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.returningDateLabel.topAnchor.constraint(equalTo: returningAirportLabel.topAnchor, constant: 20),
            self.returningDateLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.returningFlightButton.topAnchor.constraint(equalTo: returningDateLabel.bottomAnchor, constant: 11),
            self.returningFlightButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.returningFlightButton.heightAnchor.constraint(equalToConstant: 55),
            self.returningFlightButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.50),
            
            // Hotel
            self.hotelNameLabel.topAnchor.constraint(equalTo: returningFlightButton.topAnchor, constant: 75),
            self.hotelNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.hotelAddressLabel.topAnchor.constraint(equalTo: hotelNameLabel.topAnchor, constant: 20),
            self.hotelAddressLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.stayTimeLabel.topAnchor.constraint(equalTo: hotelAddressLabel.topAnchor, constant: 20),
            self.stayTimeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.hotelButton.topAnchor.constraint(equalTo: stayTimeLabel.bottomAnchor, constant: 11),
            self.hotelButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.hotelButton.heightAnchor.constraint(equalToConstant: 55),
            self.hotelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.50),
        ])
    }
    
    private func fetchDataFromFirebase(roomCode: String?) {
        guard let roomCode = roomCode else {
            return
        }

        let db = Firestore.firestore()

        // Fetch Destination
        let locationDocRef = db.document("Room/\(roomCode)/generalInfo/location")
        locationDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()

                if let location = data?["location"] as? String {
                    DispatchQueue.main.async {
                        self.locationLabel.text = "Location: \(location)"
                    }
                }
            } else {
                print("Location document does not exist")
            }
        }
        
        // Fetch Date Range
        let dateDocRef = db.document("Room/\(roomCode)/generalInfo/dateRange")
        dateDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()

                if let startDate = data?["startDate"] as? String,
                   let endDate = data?["endDate"] as? String {
                    
                    DispatchQueue.main.async {
                        self.dateLabel.text = "Date Range: \(startDate) - \(endDate)"
                    }
                }
            } else {
                print("Date document does not exist")
            }
        }
        
        // Fetch Flight
        let departingFlightDocRef = db.document("Room/\(roomCode)/flightInfo/departingFlight")
        departingFlightDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()

                if let airline = data?["airline"] as? String,
                   let airport = data?["airport"] as? String,
                   let departureDateTime = data?["departureDateTime"] as? String {
                    
                    DispatchQueue.main.async {
                        self.departingAirlineLabel.text = "Departing Airline: \(airline)"
                        self.departingAirportLabel.text = "Departing Airport: \(airport)"
                        self.departingDateLabel.text = "Departing Time: \(departureDateTime)"
                    }
                }
            } else {
                print("Date document does not exist")
            }
        }
        
        let returningFlightDocRef = db.document("Room/\(roomCode)/flightInfo/returningFlight")
        returningFlightDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()

                if let airline = data?["airline"] as? String,
                   let airport = data?["airport"] as? String,
                   let returnDateTime = data?["returnDateTime"] as? String {
                    
                    DispatchQueue.main.async {
                        self.returningAirlineLabel.text = "Returning Airline: \(airline)"
                        self.returningAirportLabel.text = "Returning Airport: \(airport)"
                        self.returningDateLabel.text = "Returning Time: \(returnDateTime)"
                    }
                }
            } else {
                print("Date document does not exist")
            }
        }
        
        // Fetch Hotel
        let hotelDocRef = db.document("Room/\(roomCode)/hotelInfo/hotelData")
        hotelDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()

                if let hotelName = data?["hotelName"] as? String,
                   let hotelAddress = data?["hotelAddress"] as? String {
                    
                    DispatchQueue.main.async {
                        self.hotelNameLabel.text = "Hotel: \(hotelName)"
                        self.hotelAddressLabel.text = "Address: \(hotelAddress)"
                    }
                }
            } else {
                print("Date document does not exist")
            }
        }
        
        let stayTimeDocRef = db.document("Room/\(roomCode)/hotelInfo/stayTime")
        stayTimeDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()

                if let startDate = data?["startDate"] as? String,
                   let endDate = data?["endDate"] as? String {
                    
                    DispatchQueue.main.async {
                        self.stayTimeLabel.text = "Stay Time: \(startDate) - \(endDate)"
                    }
                }
            } else {
                print("Date document does not exist")
            }
        }
    }
    
    func didSubmitOverviewFormWith(location: String, startDate: String, endDate: String) {
        DispatchQueue.main.async {
            self.locationLabel.text = "Location: \(location)"
            self.dateLabel.text = "Date Range: \(startDate) - \(endDate)"
        }
    }
    
    func didSubmitHotelFormWith(hotelName: String, hotelAddress: String, startDate: String, endDate: String) {
        DispatchQueue.main.async {
            self.hotelNameLabel.text = "Hotel: \(hotelName)"
            self.hotelAddressLabel.text = "Address: \(hotelAddress)"
            self.stayTimeLabel.text = "Stay Time: \(startDate) - \(endDate)"
        }
    }
    
    func didSubmitDepartingFlightInfo(airline: String, airport: String, departureDateTime: String) {
        DispatchQueue.main.async {
            self.departingAirlineLabel.text = "Departing Airline: \(airline)"
            self.departingAirportLabel.text = "Departing Airport: \(airport)"
            self.departingDateLabel.text = "Deaprting Time: \(departureDateTime)"
        }
    }
    
    func didSubmitReturningFlightInfo(airline: String, airport: String, returnDateTime: String) {
        DispatchQueue.main.async {
            self.returningAirlineLabel.text = "Returning Airline: \(airline)"
            self.returningAirportLabel.text = "Returning Airport: \(airport)"
            self.returningDateLabel.text = "Returning Time: \(returnDateTime)"
        }
    }
    
    @objc private func didTapWeather() {
        let vc = WeatherController()
        
        if let tabBarController = self.tabBarController as? TabBarController {
            vc.roomCode = tabBarController.roomCode
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapDepartingFlight() {
        let vc = DepartingFlightViewController()
        
        if let tabBarController = self.tabBarController as? TabBarController {
            vc.roomCode = tabBarController.roomCode
        }
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapReturningFlight() {
        let vc = ReturningFlightViewController()
        
        if let tabBarController = self.tabBarController as? TabBarController {
            vc.roomCode = tabBarController.roomCode
        }
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapHotel() {
        let vc = HotelViewController()
        
        if let tabBarController = self.tabBarController as? TabBarController {
            vc.roomCode = tabBarController.roomCode
        }
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapAdd() {
        let vc = AddOverviewController()
        
        if let tabBarController = self.tabBarController as? TabBarController {
            vc.roomCode = tabBarController.roomCode
        }
        vc.delegate = self
    
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
