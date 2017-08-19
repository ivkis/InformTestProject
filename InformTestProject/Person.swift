//
//  Person.swift
//  InformTestProject
//
//  Created by IvanLazarev on 19/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import Foundation


class Person {

    let name: String
    let aboutText: String
    let birthday: String

    init(json: [String: AnyObject]) {
        name = json["name"] as? String ?? ""
        aboutText = json["description"] as? String ?? ""
        birthday = json["birthday"] as? String ?? ""
    }
}

