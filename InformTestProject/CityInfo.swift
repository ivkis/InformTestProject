//
//  CityInfo.swift
//  InformTestProject
//
//  Created by IvanLazarev on 19/08/2017.
//  Copyright © 2017 IvanLazarev. All rights reserved.
//

import Foundation


class CityInfo {
    let cities: [String]
    let error: Bool
    let totalPages: Int
    let currentPage: Int

    init(json: [String: AnyObject]) {
        cities = json["cities"] as? [String] ?? []
        error = json["error"] as? Int != 0
        totalPages = json["pages"] as? Int ?? 0
        currentPage = json["page"] as? Int ?? 0
    }

    init(previousPages: CityInfo, nextPage: CityInfo) {
        cities = previousPages.cities + nextPage.cities
        error = nextPage.error
        totalPages = nextPage.totalPages
        currentPage = nextPage.currentPage
    }
}
