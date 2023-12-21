//
//  TabBarController.swift
//  UpFly
//
//  Created by Shuxin Weng on 12/4/23.
//

import UIKit

class TabBarController: UITabBarController {

    var roomCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateAppearance((UIApplication.shared.delegate as? AppDelegate)?.appearanceMode ?? .light)

        let reminderVC = ReminderViewController()
        reminderVC.roomCode = roomCode

        self.setupTabs(homeVC: OverviewController(), activityVC: EventViewController.shared, reminderVC: reminderVC)
    }

    private func setupTabs(homeVC: UIViewController, activityVC: UIViewController, reminderVC: UIViewController) {
        let home = createNav(with: "Overview", and: UIImage(systemName: "house"), vc: homeVC)

        let activity = createNav(with: "Activity List", and: UIImage(systemName: "list.bullet"), vc: activityVC)

        let reminder = createNav(with: "Reminder", and: UIImage(systemName: "list.clipboard"), vc: reminderVC)

        self.setViewControllers([home, activity, reminder], animated: true)
    }

    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        return nav
    }

    private func updateAppearance(_ mode: RoomController.AppearanceMode) {
        switch mode {
        case .light:
            overrideUserInterfaceStyle = .light
        case .dark:
            overrideUserInterfaceStyle = .dark
        }
    }
}
