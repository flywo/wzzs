//
//  Summon.swift
//  WZSC
//
//  Created by yuhua on 2019/5/27.
//  Copyright © 2019 余华. All rights reserved.
//

import Foundation


struct Summon {
    var id: Int
    var name: String
    var rank: String
    var des: String
    var imageUrl: String
    var bigUrl: String
    
    init(id: Int, name: String, rank: String, des: String) {
        self.id = id
        self.name = name
        self.rank = rank
        self.des = des
        imageUrl = "https://game.gtimg.cn/images/yxzj/img201606/summoner/\(id).jpg"
        bigUrl = "https://game.gtimg.cn/images/yxzj/img201606/summoner/\(id)-big.jpg"
    }
}
