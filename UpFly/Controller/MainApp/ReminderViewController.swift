//
//  ItemsController.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/4/23.
//

import UIKit
import FirebaseFirestore

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var roomCode: String?

    private let tableView = UITableView()
    private var items: [DocumentSnapshot] = []
    private let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tabBarController = self.tabBarController as? TabBarController {
            let roomCode = tabBarController.roomCode
            self.roomCode = tabBarController.roomCode
            fetchData(roomCode: roomCode)
        }

        configureTableView()
        configureNavigationBar()
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "customCell")

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }

    @objc func didTapAdd() {
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Item Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let itemName = alert.textFields?.first?.text {
                self.addItem(name: itemName, status: "Incomplete")
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    func fetchData(roomCode: String?) {
        guard let roomCode = roomCode else {
            print("Room code is missing.")
            return
        }

        let collectionPath = "Room/\(roomCode)/reminderItem"

        db.collection(collectionPath).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.items = documents
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell

        let item = items[indexPath.row]
        cell.configure(with: item)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            deleteItem(documentID: item.documentID)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        toggleStatus(documentID: item.documentID)
    }

    func addItem(name: String, status: String) {
        guard let roomCode = roomCode else {
            print("Room code is missing.")
            return
        }

        let documentPath = "Room/\(roomCode)/reminderItem/\(UUID().uuidString)"

        let itemData: [String: Any] = [
            "name": name,
            "status": status
        ]

        db.document(documentPath).setData(itemData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }

    func deleteItem(documentID: String) {
        guard let roomCode = roomCode else {
            print("Room code is missing.")
            return
        }

        let documentPath = "Room/\(roomCode)/reminderItem/\(documentID)"

        db.document(documentPath).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document deleted successfully")
            }
        }
    }

    func toggleStatus(documentID: String) {
        guard let roomCode = roomCode else {
            print("Room code is missing.")
            return
        }

        let documentPath = "Room/\(roomCode)/reminderItem/\(documentID)"

        db.document(documentPath).getDocument { (document, error) in
            if let document = document, document.exists {
                let currentStatus = document["status"] as? String ?? ""
                let newStatus = (currentStatus == "Complete") ? "Incomplete" : "Complete"
                self.updateItem(documentID: documentID, status: newStatus)
            } else {
                print("Document does not exist")
            }
        }
    }

    func updateItem(documentID: String, status: String) {
        guard let roomCode = roomCode else {
            print("Room code is missing.")
            return
        }

        let documentPath = "Room/\(roomCode)/reminderItem/\(documentID)"

        db.document(documentPath).updateData([
            "status": status
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document updated successfully")
            }
        }
    }
}
