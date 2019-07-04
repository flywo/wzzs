//
//  Net.swift
//  WZSC
//
//  Created by yuhua on 2019/5/27.
//  Copyright © 2019 余华. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Net {
    static let MainUrl = "https://pvp.qq.com/web201605/"
    static let HeroList = "js/herolist.json"
    static let SummonerList = "js/summoner.json"
    static let ItemList = "js/item.json"
    static let MingList = "js/ming.json"
    static let VideoUrl1 = "https://gicp.qq.com/wmp/data/js/v3/WMP_PVP_WEBSITE_NEWBEE_DATA_V1.js"
    static let VideoUrl2 = "https://gicp.qq.com/wmp/data/js/v3/WMP_PVP_WEBSITE_DATA_18_VIDEO_V3.js"
    static let VideoSearch = "https://apps.game.qq.com/wmp/v3.1/public/search.php"
    static let VideoInfo = "https://h5vv.video.qq.com/getinfo"
    
    static func GetHero(fail: @escaping ()->Void = {}, success: @escaping ([Hero])->Void = { _ in }) -> DataRequest? {
        print("获取英雄")
        if CommonData.heros != nil && !CommonData.heros!.isEmpty {
            print("直接返回已存在数据")
            success(CommonData.heros!.reversed())
            return nil
        }
        CommonData.heros = [Hero]()
        return Alamofire.request(MainUrl+HeroList, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for hero in json.arrayValue {
                    CommonData.heros!.append(Hero(name: hero["cname"].stringValue,
                                       id: hero["ename"].intValue,
                                       newType: hero["new_type"].intValue,
                                       heroType: hero["hero_type"].intValue,
                                       payType: hero["pay_type"].intValue))
                }
                print("返回获取到的数据")
                success(CommonData.heros!.reversed())
            case .failure(let error):
                print(error)
                fail()
            }
        }
    }
    
    static func GetEquip(fail: @escaping ()->Void = {}, success: @escaping ([Equip])->Void = { _ in }) -> DataRequest? {
        print("获取物品")
        if CommonData.items != nil && !CommonData.items!.isEmpty {
            print("直接返回已存在数据")
            success(CommonData.items!)
            return nil
        }
        CommonData.items = [Equip]()
        return Alamofire.request(MainUrl+ItemList, method: .get).validate().responseJSON(queue: DispatchQueue.global(), options: .mutableLeaves) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for equip in json.arrayValue {
                    CommonData.items!.append(Equip(
                        id: equip["item_id"].intValue,
                        name: equip["item_name"].stringValue,
                        type: equip["item_type"].intValue,
                        price: equip["price"].intValue,
                        buy: equip["total_price"].intValue,
                        des: equip["des1"].stringValue
                            .replacingOccurrences(of: "<p>", with: "")
                            .replacingOccurrences(of: "<br>", with: "\n")
                            .replacingOccurrences(of: "</p>", with: ""),
                        des2: equip["des2"].string?
                            .replacingOccurrences(of: "<p>", with: "")
                            .replacingOccurrences(of: "<br>", with: "\n")
                            .replacingOccurrences(of: "</p>", with: "")))
                }
                print("返回获取到的数据")
                success(CommonData.items!)
            case .failure(let error):
                print(error)
                fail()
            }
        }
    }
    
    static func GetMing(fail: @escaping ()->Void = {}, success: @escaping ([Ming])->Void = { _ in }) -> DataRequest? {
        print("获取铭文")
        if CommonData.mings != nil && !CommonData.mings!.isEmpty {
            print("直接返回已存在数据")
            success(CommonData.mings!)
            return nil
        }
        CommonData.mings = [Ming]()
        return Alamofire.request(MainUrl+MingList, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for ming in json.arrayValue {
                    CommonData.mings!.append(Ming(id: ming["ming_id"].stringValue,
                                       type: ming["ming_type"].stringValue,
                                       grade: ming["ming_grade"].stringValue,
                                       name: ming["ming_name"].stringValue,
                                       des: ming["ming_des"].stringValue
                                        .replacingOccurrences(of: "<p>", with: "")
                                        .replacingOccurrences(of: "</p>", with: "\n")))
                }
                print("返回获取到的数据")
                success(CommonData.mings!)
            case .failure(let error):
                print(error)
                fail()
            }
        }
    }
    
    static func GetSummon(fail: @escaping ()->Void = {}, success: @escaping ([Summon])->Void = { _ in }) -> DataRequest? {
        print("获取召唤师技能")
        if CommonData.summons != nil && !CommonData.summons!.isEmpty {
            print("直接返回已存在数据")
            success(CommonData.summons!)
            return nil
        }
        CommonData.summons = [Summon]()
        return Alamofire.request(MainUrl+SummonerList, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for summon in json.arrayValue {
                    CommonData.summons!.append(Summon(id: summon["summoner_id"].intValue,
                                         name: summon["summoner_name"].stringValue,
                                         rank: summon["summoner_rank"].stringValue,
                                         des: summon["summoner_description"].stringValue))
                }
                print("返回获取到的数据")
                success(CommonData.summons!)
            case .failure(let error):
                print(error)
                fail()
            }
        }
    }
    
    static func GetHeroInfo(hero: Hero, fail: @escaping ()->Void = {}, success: @escaping (HeroInfo)->Void) -> DataRequest? {
        print("获取英雄详情")
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
        return Alamofire.request(hero.heroUrl, method: .get).validate().responseString(queue: DispatchQueue.global(), encoding: String.Encoding(rawValue: encoding)) { response in
            switch response.result {
            case .success(let value):
                Parser.ParseHtml(hero: hero, html: value, fail: fail, success: success)
            case .failure(let error):
                print(error)
                fail()
            }
        }
    }
    
    static func GetVideo(fail: @escaping ()->Void = {}, success: @escaping ()->Void = {}) -> [DataRequest]? {
        print("获取视频列表")
        func checkHeader(str: String) -> String {
            if str.count < 6 {
                return str
            }
            if str.substring(from: 0, length: 5) == "https" {
                return str
            } else {
                return "https:\(str)"
            }
        }
        func checkDes(str: String) -> String {
            if str.count > 60 {
                return (str.substring(from: 0, length: 60) ?? "") + "..."
            }
            return str
        }
        
        let request1 = Alamofire.request(VideoUrl1, method: .get).validate().responseString(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                do {
                    let rex = try NSRegularExpression(pattern: "\\{.*\\}", options: NSRegularExpression.Options.caseInsensitive)
                    let result = rex.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count))
                    if let range = result?.range {
                        let dic = JSON(parseJSON: value.substring(from: range.location, length: range.length) ?? "")
                        let news = dic["news"].dictionaryValue
                        let video = dic["video"].dictionaryValue
                        news.forEach { (key, value) in
                            if !value.isEmpty {
                                value.arrayValue.forEach { content in
                                    let data = Video()
                                    data.id = content["iNewsId"].stringValue
                                    data.title = content["sTitle"].stringValue
                                    data.author = content["sAuthor"].stringValue
                                    data.desc = checkDes(str: content["sDesc"].stringValue)
                                    data.img = checkHeader(str: content["sIMG"].stringValue)
                                    data.time = content["sIdxTime"].stringValue
                                    data.totalPlay = content["iTotalPlay"].stringValue
                                    data.playTime = content["iTime"].stringValue
                                    data.heroName = key
                                    data.insert()
                                }
                            }
                        }
                        video.forEach { (key, value) in
                            if !value.isEmpty {
                                value.arrayValue.forEach { content in
                                    let data = Video()
                                    data.id = content["iVideoId"].stringValue
                                    data.title = content["sTitle"].stringValue
                                    data.author = content["sAuthor"].stringValue
                                    data.desc = checkDes(str: content["sDesc"].stringValue)
                                    data.img = checkHeader(str: content["sIMG"].stringValue)
                                    data.time = content["sIdxTime"].stringValue
                                    data.totalPlay = content["iTotalPlay"].stringValue
                                    data.playTime = content["iTime"].stringValue
                                    data.heroName = key
                                    data.insert()
                                }
                            }
                        }
                    }
                } catch {
                    print("解析发生错误\(error.localizedDescription)")
                }
            case .failure(let error):
                print(error)
                fail()
            }
        }
        let request2 = Alamofire.request(VideoUrl2, method: .get).validate().responseString(queue: DispatchQueue.global()) { response in
            switch response.result {
            case .success(let value):
                do {
                    let rex = try NSRegularExpression(pattern: "\\{.*\\}", options: NSRegularExpression.Options.caseInsensitive)
                    let result = rex.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count))
                    if let range = result?.range {
                        let dic = JSON(parseJSON: value.substring(from: range.location, length: range.length) ?? "")
                        let video = dic.dictionaryValue.values
                        video.forEach { value in
                            let name = value["sTag"].stringValue
                            value["jData"].arrayValue.forEach { content in
                                let data = Video()
                                data.id = content["iId"].stringValue
                                data.title = content["sTitle"].stringValue
                                data.author = content["sAuthor"].stringValue
                                data.desc = checkDes(str: content["sDesc"].stringValue)
                                data.img = checkHeader(str: content["sIMG"].stringValue)
                                data.time = content["sIdxTime"].stringValue
                                data.totalPlay = content["iTotalPlay"].stringValue
                                data.playTime = content["iTime"].stringValue
                                data.heroName = name
                                data.insert()
                            }
                        }
                    }
                } catch {
                    print("解析发生错误\(error.localizedDescription)")
                }
            case .failure(let error):
                print(error)
                fail()
            }
        }
        return [request1, request2]
    }
    
    static func GetVideoUrl(videoID: String, fail: @escaping ()->Void = {}, success: @escaping (String)->Void = {_ in }) {
        func getSVID(value: String) -> String? {
            do {
                let rex = try NSRegularExpression(pattern: "\"sVID\":\"[0-9a-zA-Z]{11}\"", options: NSRegularExpression.Options.caseInsensitive)
                let result = rex.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count))
                if let res = result {
                    return value.substring(from: res.range.location+8, length: 11)
                } else {
                    return nil
                }
            } catch {
                print("解析发生错误:\(error.localizedDescription)")
                return nil
            }
        }
        func getURL(value: String) -> String? {
            do {
                let rex = try NSRegularExpression(pattern: "\\{.*\\}", options: NSRegularExpression.Options.caseInsensitive)
                let result = rex.firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count))
                if let res = result {
                    if let string = value.substring(from: res.range.location, length: res.range.length) {
                        let json = JSON(parseJSON: string)
                        let url = json["vl"]["vi"][0]["ul"]["ui"][0]["url"].stringValue
                        let name = json["vl"]["vi"][0]["fn"].stringValue
                        let key = json["vl"]["vi"][0]["fvkey"].stringValue
                        return url+name+"?vkey="+key
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } catch {
                print("解析发生错误:\(error.localizedDescription)")
                return nil
            }
        }
        Alamofire.request(VideoSearch, method: .post, parameters: ["source" : "pvpweb_detail", "id" : videoID, "p0" : 18])
            .validate().responseString(queue: DispatchQueue.global()) { response in
                switch response.result {
                case .success(let value):
                    if let sVID = getSVID(value: value) {
                        Alamofire.request(VideoInfo, method: .post, parameters: ["vids" : sVID, "otype" : "json", "ehost" : "https://pvp.qq.com", "platform" : 11001, "sdtfrom" : "v1010"])
                            .validate().responseString(queue: DispatchQueue.global()) { response in
                                switch response.result {
                                case .success(let value):
                                    if let url = getURL(value: value) {
                                        success(url)
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}
