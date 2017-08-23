//
//  BirthdayDateViewController.swift
//  InformTestProject
//
//  Created by IvanLazarev on 22/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class BirthdayDateViewController: UIViewController {

    var allBirthdays: API.BirthdaysResponse?
    var birthdays: [BirthdayInfo]?

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        updateButton.isHidden = true

//        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
}

extension BirthdayDateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdays?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.birthdayDateCell, for: indexPath)!
        let birthday = birthdays![indexPath.row]
        cell.textLabel?.text = String(birthday.time)
        cell.detailTextLabel?.text = birthday.name
        return cell
    }
}
