//
//  CustomTableViewCell.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/8/23.
//

import UIKit
import FirebaseFirestore

class CustomTableViewCell: UITableViewCell {

    var nameLabel = UILabel()
    var statusLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        statusLabel.textColor = UIColor.gray

        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with reminderItem: DocumentSnapshot) {
        nameLabel.text = reminderItem["name"] as? String

        let status = reminderItem["status"] as? String ?? ""
        statusLabel.text = "Status: \(status)"
        statusLabel.textColor = (status == "Complete") ? .green : .red
    }
}
