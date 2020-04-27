//
//  MainScreen.swift
//  Atrip
//
//  Created by jimmy on 2020/04/08.
//  Copyright © 2020 jimmy. All rights reserved.
//

import Foundation

/*
 http://actrip.co.kr/act/callback/appdata.php
 main_swiper / main_tip / main_hashtag / main_banner / main_plan
 */

struct MainScreenDataModel: Decodable {
    let mainSwiper: [MainScreenDataBanner]
    let mainTip: MainTip?
    let mainHashtag: [MainScreenDataHashTag]
    let mainBanner: MainScreenDataBanner?
    let mainPlan: MainPlan?
    
    init(json: [String: Any]) {
        mainSwiper = json["main_swiper"] as? [MainScreenDataBanner] ?? []
        mainTip = json["main_tip"] as? MainTip ?? nil
        mainHashtag = json["main_hashtag"] as? [MainScreenDataHashTag] ?? []
        mainBanner = json["main_banner"] as? MainScreenDataBanner ?? nil
        mainPlan = json["main_plan"] as? MainPlan ?? nil
    }
    
    enum CodingKeys : String, CodingKey{
        case mainSwiper = "main_swiper"
        case mainTip = "main_tip"
        case mainHashtag = "main_hashtag"
        case mainBanner = "main_banner"
        case mainPlan = "main_plan"
    }
}

struct MainScreenDataBanner: Decodable {
    let imgurl: String
    let link: String
    let useyn: String
    
    init(json: [String: Any]) {
        imgurl = json["imgurl"] as? String ?? ""
        link = json["link"] as? String ?? ""
        useyn = json["useyn"] as? String ?? ""
    }
}

struct MainScreenDataHashTag: Decodable {
    let text: String
    let link: String
    let useyn: String
    
    init(json: [String: Any]) {
        text = json["text"] as? String ?? ""
        link = json["link"] as? String ?? ""
        useyn = json["useyn"] as? String ?? ""
    }
}

struct MainTip: Decodable {
    let titlename: String
    let data: [MainScreenDataBanner]
    
    init(json: [String: Any]) {
        titlename = json["titlename"] as? String ?? ""
        data = json["data"] as? [MainScreenDataBanner] ?? []
    }
}

struct MainPlan: Decodable {
    let titlename: String
    let data: [MainScreenDataBanner]
    
    init(json: [String: Any]) {
        titlename = json["titlename"] as? String ?? ""
        data = json["data"] as? [MainScreenDataBanner] ?? []
    }
}
