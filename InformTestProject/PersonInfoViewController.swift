//
//  PersonInfoViewController.swift
//  InformTestProject
//
//  Created by IvanLazarev on 19/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class PersonInfoViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        clearLabels()
    }

    @IBAction func updateButtonTapped(_ sender: Any) {
        loadData()
    }

    func loadData() {
        clearLabels()
        API.shared.getPersonInfo { personInfo in
            if let personInfo = personInfo {
                self.nameLabel.text = personInfo.name
                self.dateLabel.text = personInfo.birthday
                self.descriptionLabel.text = personInfo.aboutText
            } else {
                let alertController = UIAlertController(title: "Данные отсутствуют.", message: "Извините, произошла ошибка. Обновите запрос.", preferredStyle: .alert)
                let alertActionUpdate = UIAlertAction(title: "Обновить", style: .default, handler: { action in
                    self.loadData()
                })
                let alertActionCancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
                alertController.addAction(alertActionUpdate)
                alertController.addAction(alertActionCancel)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func clearLabels() {
        self.nameLabel.text = ""
        self.dateLabel.text = ""
        self.descriptionLabel.text = ""
    }
}
