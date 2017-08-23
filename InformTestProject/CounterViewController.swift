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
    var currentValue: Int? {
        get {
            return Int(valueCounterLabel.text ?? "invalid")
        }
        set {
            self.valueCounterLabel.text = newValue == nil ? "" : String(newValue!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.valueCounterLabel.text = ""

        loadData()
    }

    func loadData() {
        API.shared.getCounter { valueCounter in
            if let valueCounter = valueCounter {
                self.currentValue = valueCounter
            } else {
                print("error counter")
            }
        }
    }

    func sendData() {
        guard let currentValue = Int(valueCounterLabel.text ?? "invalid") else {
            return
        }
    }

    @IBAction func incrementButtonTapped(_ sender: Any) {
        guard let currentValue = currentValue else {
            return
        }
        self.currentValue = currentValue + 1
        // sendData later
    }


    @IBAction func decrementButtonTapped(_ sender: Any) {
        guard let currentValue = currentValue else {
            return
        }
        self.currentValue = currentValue - 1
        // sendData later
    }
}
