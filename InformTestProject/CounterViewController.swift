//
//  CounterViewController.swift
//  InformTestProject
//
//  Created by IvanLazarev on 23/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class CounterViewController: UIViewController {

    var dataLoad: Bool?
    var counterTimer = Timer()
    var serverValue: Int?
    var currentValue: Int? {
        get {
            return Int(valueCounterLabel.text ?? "invalid")
        }
        set {
            self.valueCounterLabel.text = newValue == nil ? "" : String(newValue!)
        }
    }
    var isSendingRequest = false

    @IBOutlet weak var valueCounterLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.valueCounterLabel.text = ""

        loadData()
    }

    func loadData() {
        API.shared.getCounter { valueCounter in
            if let valueCounter = valueCounter {
                print("Counter: received initial value: \(valueCounter)")
                self.currentValue = valueCounter
                self.serverValue = valueCounter
            } else {
                print("error counter")
            }
        }
    }

    func sendData() {
        guard let currentValue = currentValue, let serverValue = serverValue, !isSendingRequest else {
            return
        }
        counterTimer.invalidate()
        let delta = currentValue - serverValue
        print("Counter: sending delta \(delta)")
        isSendingRequest = true
        API.shared.setCounter(delta: delta) { valueCounter in
            self.isSendingRequest = false
            if let valueCounter = valueCounter {
                print("Counter: received updated value: \(valueCounter)")
                self.serverValue = valueCounter
            } else {
                print("error sendData")
            }
        }
    }

    @IBAction func incrementButtonTapped(_ sender: Any) {
        counterTimer.invalidate()
        guard let currentValue = currentValue else {
            return
        }
        self.currentValue = currentValue + 1
        counterTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.sendData()
        }
    }


    @IBAction func decrementButtonTapped(_ sender: Any) {
        counterTimer.invalidate()
        guard let currentValue = currentValue else {
            return
        }
        self.currentValue = currentValue - 1
        counterTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.sendData()
        }
    }
}
