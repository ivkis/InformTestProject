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

    fileprivate func getJSON(url: URL, callback: @escaping (Any?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                callback(nil)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                callback(json)
            } catch {
                print(error)
                callback(nil)
            }
            }.resume()
    }

    func getPersonInfo(callback: @escaping (Person?) -> Void) {
        let asyncCallback = { (person: Person?) in
            DispatchQueue.main.async {
                callback(person)
            }
        }
        getJSON(url: Constants.urlPersonInfo) { json in
            guard let results = json as? [String: AnyObject] else {
                print("Non-dictionary response")
                asyncCallback(nil)
                return
            }
            let personInfo = Person(json: results)
            asyncCallback(personInfo)
        }
    }

    func getCities(page: Int, callback: @escaping (CityInfo?) -> Void) {
        let asyncCallback = { (city: CityInfo?) in
            DispatchQueue.main.async {
                callback(city)
            }
        }
        var components = URLComponents(url: Constants.urlCities, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page))
        ]
        getJSON(url: components.url!) { json in
            guard let results = json as? [String: AnyObject] else {
                print("Non-dictionary response")
                asyncCallback(nil)
                return
            }
            let cityInfo = CityInfo(json: results)
            asyncCallback(cityInfo)
        }
    }
}

