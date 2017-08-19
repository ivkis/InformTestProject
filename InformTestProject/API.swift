//
//  API.swift
//  InformTestProject
//
//  Created by IvanLazarev on 19/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import Foundation
import UIKit


class API {

    static let shared = API()

    func getPersonInfo(callback: @escaping (Person?) -> Void) {
        let asyncCallback = { (person: Person?) in
            DispatchQueue.main.async {
                callback(person)
            }
        }
        URLSession.shared.dataTask(with: Constants.urlPersonInfo) { data, response, error in
            guard let data = data, error == nil else {
                asyncCallback(nil)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                guard let results = json as? [String: AnyObject] else {
                    print("Non-dictionary response")
                    asyncCallback(nil)
                    return
                }
                let personInfo = Person(json: results)
                asyncCallback(personInfo)
            } catch {
                print(error)
                asyncCallback(nil)
            }
        }.resume()
    }
}

