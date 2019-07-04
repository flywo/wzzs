//
//  Video.swift
//  WZSC
//
//  Created by yuhua on 2019/5/31.
//  Copyright © 2019 余华. All rights reserved.
//

import Foundation
import SQLite

class Video {
    
    var id: String?
    var title: String?
    var author: String?
    var desc: String?
    var img: String?
    var time: String?
    var playTime: String?
    var totalPlay: String?
    var heroName: String?
    
    static let db = try? Connection(.temporary)
    static let video = Table("video")
    
    static let id = Expression<String>("id")
    static let title = Expression<String>("title")
    static let author = Expression<String>("author")
    static let desc = Expression<String>("desc")
    static let img = Expression<String>("img")
    static let time = Expression<String>("time")
    static let totalPlay = Expression<String>("totalPlay")
    static let heroName = Expression<String>("heroName")
    static let playTime = Expression<String>("playTime")
    
    static func creatTable() {
        do {
            try db?.run(video.create { t in
                t.column(id)
                t.column(title)
                t.column(author)
                t.column(desc)
                t.column(img)
                t.column(time)
                t.column(totalPlay)
                t.column(heroName)
                t.column(playTime)
            })
            print("创建表成功")
        } catch {
            print("创建表失败")
        }
    }
    
    func insert() {
        let insert = Video.video.insert(
            Video.id <- id ?? "",
            Video.title <- title ?? "",
            Video.author <- author ?? "",
            Video.desc <- desc ?? "",
            Video.img <- img ?? "",
            Video.time <- time ?? "",
            Video.totalPlay <- totalPlay ?? "",
            Video.heroName <- heroName ?? "",
            Video.playTime <- playTime ?? ""
        )
        do {
            try Video.db?.run(insert)
        } catch {
            print("插入失败\(id ?? "")")
        }
    }
}
