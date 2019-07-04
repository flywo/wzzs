//
//  Ming.swift
//  WZSC
//
//  Created by yuhua on 2019/5/27.
//  Copyright © 2019 余华. All rights reserved.
//

import Foundation


struct Ming {
    var id: String
    var type: String
    var grade: String
    var name: String
    var des: String
    var imageUrl: String
    
    init(id: String, type: String, grade: String, name: String, des: String) {
        self.id = id
        self.type = type
        self.grade = grade
        self.name = name
        self.des = des
        imageUrl = "https://game.gtimg.cn/images/yxzj/img201606/mingwen/\(id).png"
    }
}
