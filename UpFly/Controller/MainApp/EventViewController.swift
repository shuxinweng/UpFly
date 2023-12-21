//
//  EventViewController.swift
//  UpFly
//
//  Created by Shuxin Weng on 11/27/23.
//

import UIKit
import MapKit
import CoreLocation

class EventViewController: UIViewController {
    
    static let shared = EventViewController()
    
    var places = [String]()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        LocationService.shared.addLocationUpdatedHandler { [weak self] location in
            self?.fetchPlaces(location: location)
        }
    }
    
    private func fetchPlaces(location: CLLocationCoordinate2D) {
        let searchSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let searchRegion = MKCoordinateRegion(center: location, span: searchSpan)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = searchRegion
        searchRequest.resultTypes = .pointOfInterest
        searchRequest.naturalLanguageQuery = "Things To Do"
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let mapItems = response?.mapItems else {
                return
            }
            
            let results = mapItems.map({$0.name ?? "No Name Found"})
            DispatchQueue.main.async { [weak self] in
                self?.places = results
                self?.tableView.reloadData()
            }
        }
    }
}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
