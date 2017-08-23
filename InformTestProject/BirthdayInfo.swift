//
//  BirthdayInfo.swift
//  InformTestProject
//
//  Created by IvanLazarev on 22/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import UIKit


class BirthdayInfo {

    let time: TimeInterval
    let name: String

    init(json: [String: AnyObject]) {
        time = json["time"] as? TimeInterval ?? 0
        name = json["description"] as? String ?? ""
    }
}
