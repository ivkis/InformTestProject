//
//  BirthdayDateViewController.swift
//  InformTestProject
//
//  Created by IvanLazarev on 22/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class BirthdayDateViewController: UIViewController {

    var birthdayTimer = Timer()
    var allBirthdays: API.BirthdaysResponse?
    var birthdays: [BirthdayInfo]?

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        updateButton.isHidden = true
        startBirthdayTimer()

        loadData()
    }

    @IBAction func updateButtonTapped(_ sender: Any) {
        updateButton.isHidden = true
        loadData()
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            birthdays = allBirthdays?.past
        } else {
            birthdays = allBirthdays?.future
        }
        tableView.reloadData()
    }

    func loadData() {
        API.shared.getBirthdayDate { response in
            if let response = response {
                self.allBirthdays = response
                self.segmentedControl.selectedSegmentIndex = 0
                self.segmentedControlChanged(self.segmentedControl)
            } else {
                self.updateButton.isHidden = false
            }
        }
    }

    func updateVisibleLabels() {
        guard let indexPaths = tableView.indexPathsForVisibleRows else {
            return
        }
        let now = Date().timeIntervalSince1970
        for indexPath in indexPaths {
            let cell = tableView.cellForRow(at: indexPath)
            let birthday = birthdays![indexPath.row]
            let intervalFromBirthday = abs(now - birthday.time)
            cell?.textLabel?.text = stringFromTime(interval: intervalFromBirthday)
        }
    }

    func startBirthdayTimer() {
        birthdayTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.updateVisibleLabels()
        }
    }

    func stringFromTime(interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: interval) ?? ""
    }
}

extension BirthdayDateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdays?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.birthdayDateCell, for: indexPath)!
        let birthday = birthdays![indexPath.row]
        let intervalFromBirthday = abs(Date().timeIntervalSince1970 - birthday.time)

        cell.textLabel?.text = stringFromTime(interval: intervalFromBirthday)
        cell.detailTextLabel?.text = birthday.name
        return cell
    }
}
