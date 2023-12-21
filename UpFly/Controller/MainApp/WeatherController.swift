//
//  WeatherController.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/4/23.
//

import UIKit
import FirebaseFirestore

class WeatherController: UIViewController {

    var roomCode: String?

    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.text = "Weather"
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Temperature: Loading..."
        return label
    }()

    private let conditionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Conditions: Loading..."
        return label
    }()

    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Humidity: Loading..."
        return label
    }()

    private let windLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Wind Speed: Loading..."
        return label
    }()

    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "City: Loading..."
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchLocation()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        let labelsStackView = UIStackView(arrangedSubviews: [weatherLabel, temperatureLabel, conditionsLabel, humidityLabel, windLabel, cityNameLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 10
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(labelsStackView)

        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            labelsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    private func fetchWeatherForLocation(_ location: String) {
        guard let apiKey = "48e58afbe0fc2b3edf7cf00724fe504a".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Invalid API key")
            return
        }

        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(location)&appid=\(apiKey)"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error fetching weather data: \(error.localizedDescription)")
                    return
                }

                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let weatherData = try decoder.decode(WeatherData.self, from: data)

                        DispatchQueue.main.async {
                            self.updateUI(with: weatherData)
                        }
                    } catch {
                        print("Error parsing weather data: \(error.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }

    private func fetchLocation() {
        let db = Firestore.firestore()

        let locationPath = "Room/\(roomCode ?? "")/generalInfo/location"
        let locationDocRef = db.document(locationPath)
        locationDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()

                if let location = data?["location"] as? String {
                    DispatchQueue.main.async {
                        self.fetchWeatherForLocation(location)
                    }
                }
            } else {
                print(locationPath)
                print("Location document does not exist")
            }
        }
    }

    private func updateUI(with weatherData: WeatherData) {
        temperatureLabel.text = String(format: "Temperature: %.2f°C", weatherData.main.temp - 273.15)
        conditionsLabel.text = "Conditions: \(weatherData.weather.first?.description ?? "N/A")"
        humidityLabel.text = "Humidity: \(weatherData.main.humidity)%"
        windLabel.text = "Wind Speed: \(weatherData.wind.speed) m/s"
        cityNameLabel.text = "City: \(weatherData.name)"
    }
}

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let name: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Double
}

struct Weather: Codable {
    let description: String
}

struct Wind: Codable {
    let speed: Double
}
