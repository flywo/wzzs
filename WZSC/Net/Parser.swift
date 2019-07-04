//
//  Parser.swift
//  WZSC
//
//  Created by yuhua on 2019/5/27.
//  Copyright © 2019 余华. All rights reserved.
//

import Foundation
import SwiftSoup

class Parser {
    
    static func ParseHtml(hero: Hero, html: String, fail: @escaping ()->Void = {}, success: (HeroInfo)->Void) {
        do {
            let doc = try SwiftSoup.parse(html)
            
            //皮肤
            var heroInfo = HeroInfo()
            var skinsArr = [[String]]()
            var skinNmaes = [String]()
            let skins = try doc.getElementsByClass("pic-pf-list pic-pf-list3").attr("data-imgname").components(separatedBy: "|")
            for (index, skin) in skins.enumerated() {
                skinNmaes.append(skin)
                skinsArr.append(["https://game.gtimg.cn/images/yxzj/img201606/heroimg/\(hero.id)/\(hero.id)-smallskin-\(index+1).jpg",
                    "https://game.gtimg.cn/images/yxzj/img201606/skin/hero-info/\(hero.id)/\(hero.id)-bigskin-\(index+1).jpg"
                ])
            }
            heroInfo.skins = skinsArr
            heroInfo.skin = skinNmaes
            
            //技能
            var skillsArr = [[String]]()
            let skillNames = try doc.getElementsByClass("skill-name").array()
            let skillDesc = try doc.getElementsByClass("skill-desc").array()
            let skillTips = try doc.getElementsByClass("skill-tips").array()
            for (index, name) in skillNames.enumerated() {
                let n1 = try name.child(0).text()
                if (n1.isEmpty) {
                    continue
                }
                let n2 = try name.child(1).text()
                let n3 = try name.child(2).text()
                let des = try skillDesc[index].text()
                let tip = try skillTips[index].text()
                skillsArr.append([n1, "https://game.gtimg.cn/images/yxzj/img201606/heroimg/\(hero.id)/\(hero.id)\(index)0.png", "\(n2)  \(n3)", des, tip])
            }
            heroInfo.skills = skillsArr
            
            //铭文
            var mingsArr = [String]()
            let mings = try doc.getElementsByClass("sugg-u1").attr("data-ming").components(separatedBy: "|")
            let mingTip = try doc.getElementsByClass("sugg-tips").text()
            for ming in mings {
                mingsArr.append(ming)
            }
            heroInfo.ming = mingsArr
            heroInfo.mingTips = mingTip
            
            //装备
            var itemsArr = [[String]]()
            var itemsTipsArr = [String]()
            let items = try doc.getElementsByClass("equip-info l").array()
            for item in items {
                let data = try item.child(0).attr("data-item")
                let tips = try item.child(1).text()
                itemsArr.append(data.components(separatedBy: "|"))
                itemsTipsArr.append(tips)
            }
            heroInfo.items = itemsArr
            heroInfo.itemsTips = itemsTipsArr
            
            //故事
            let story = try doc.getElementsByClass("pop-bd").first()?.html() ?? ""
            heroInfo.story = story
            
            success(heroInfo)
        } catch {
            print("error")
            fail()
        }
    }
}
