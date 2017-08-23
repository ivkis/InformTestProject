//
//  CounterViewController.swift
//  InformTestProject
//
//  Created by IvanLazarev on 23/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class CounterViewController: UIViewController {

    @IBOutlet weak var valueCounterLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.valueCounterLabel.text = ""

        loadData()
    }

    func loadData() {
        API.shared.getCounter { valueCounter in
            if let valueCounter = valueCounter {
                self.valueCounterLabel.text = String(valueCounter)
            } else {
                print("error counter")
            }
        }
    }
}
