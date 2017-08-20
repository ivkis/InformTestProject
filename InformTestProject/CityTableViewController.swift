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
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cityInfo?.cities.count ?? 0
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cityCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cityCell)!
            cityCell.textLabel?.text = cityInfo?.cities[indexPath.row]
            return cityCell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cityLoadingCell)!
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            loadData()
        }
    }

    func loadData() {
        let page = cityInfo?.currentPage == nil ? 0 : cityInfo!.currentPage + 1
        API.shared.getCities(page: page) { cityInfo in
            if let cityInfo = cityInfo, !cityInfo.error {
                if let previousCityInfo = self.cityInfo {
                    self.cityInfo = CityInfo(previousPages: previousCityInfo, nextPage: cityInfo)
                } else {
                    self.cityInfo = cityInfo
                }
                self.tableView.reloadData()
            } else {
                if self.tableView.numberOfRows(inSection: 0) > 0 {
                    let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0) - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                let alertController = UIAlertController(title: "Нет ответа от сервера", message: "Извините, произошла ошибка. Попробуйте позже", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
