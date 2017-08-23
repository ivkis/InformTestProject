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
    struct BirthdaysResponse {
        let future: [BirthdayInfo]
        let past: [BirthdayInfo]
    }

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

    func getBirthdayDate(callback: @escaping (BirthdaysResponse?) -> Void) {
        let asyncCallback = { (response: BirthdaysResponse? ) in
            DispatchQueue.main.async {
                callback(response)
            }
        }
        getJSON(url: Constants.urlBirthday) { json in
            guard let json = json as? [String: AnyObject] else {
                print("Non-dictionary response")
                asyncCallback(nil)
                return
            }
            guard let past = json["past"] as? [[String: AnyObject]], let future = json["future"] as? [[String: AnyObject]] else {
                asyncCallback(nil)
                return
            }
            let pastBirthdays = past.map { dict in BirthdayInfo(json: dict) }
            let futureBirthdays = future.map { dict in BirthdayInfo(json: dict) }
            asyncCallback(BirthdaysResponse(future: futureBirthdays, past: pastBirthdays))
        }
    }

    func getCounter(callback: @escaping (Int?) -> Void) {
        let asyncCallback = { (response: Int?) in
            DispatchQueue.main.async {
                callback(response)
            }
        }
        getJSON(url: Constants.urlCounter) { json in
            guard let json = json as? [String: AnyObject] else {
                print("Non-dictionary response")
                asyncCallback(nil)
                return
            }
            let valueCounter = Int(json["value"] as? String ?? "invalid")
            asyncCallback(valueCounter)
        }
    }

    func setCounter(delta: Int, callback: @escaping (Int?) -> Void) {
        let asyncCallback = { (response: Int?) in
            DispatchQueue.main.async {
                callback(response)
            }
        }
        var components = URLComponents(url: Constants.urlCounter, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "delta", value: String(abs(delta))),
            URLQueryItem(name: "action", value: delta >= 0 ? "increment": "decrement")
        ]
        getJSON(url: components.url!) { json in
            guard let json = json as? [String: AnyObject] else {
                print("Unable to send data")
                asyncCallback(nil)
                return
            }
            let valueCounter = Int(json["value"] as? String ?? "invalid")
            asyncCallback(valueCounter)
        }
    }
}


