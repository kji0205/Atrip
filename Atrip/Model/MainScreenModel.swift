//
//  MainScreen.swift
//  Atrip
//
//  Created by jimmy on 2020/04/08.
//  Copyright © 2020 jimmy. All rights reserved.
//

import Foundation

// main_swiper, main_hashtag, main_banner, main_plan

struct MainScreenModel: Codable {
    let mainSwiper: [MainScreenDetailModel]?
    let mainTip: MainTip?
    let mainHashtag: [MainScreenDetailModel]?
    let mainBanner: [MainScreenDetailModel]?
    let mainPlan: [MainScreenDetailModel]?
    
    enum CodingKeys: String, CodingKey {
        case mainSwiper = "main_swiper"
        case mainTip = "main_tip"
        case mainHashtag = "mainHashtag"
        case mainBanner = "mainBanner"
        case mainPlan = "mainPlan"
    }
}

struct MainScreenDetailModel: Codable {
    let text: String?
    let imgurl: String?
    let link: String?
    let useyn: String?
}

// main_tip
struct MainTip: Codable {
    let titlename: String?
    let data: [MainScreenDetailModel]?
}

