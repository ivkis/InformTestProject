//
//  CityTableViewController.swift
//  InformTestProject
//
//  Created by IvanLazarev on 20/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import Foundation
import UIKit


class CityTableViewController: UITableViewController {
    var cityInfo: CityInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.getCities(page: 0) { cityInfo in
            self.cityInfo = cityInfo
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityInfo?.cities.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cell)
        cityCell?.textLabel?.text = cityInfo?.cities[indexPath.row]
        return cityCell!
    }
}
