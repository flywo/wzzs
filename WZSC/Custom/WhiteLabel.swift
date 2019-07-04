//
//  WhiteLabel.swift
//  WZSC
//
//  Created by yuhua on 2019/5/28.
//  Copyright © 2019 余华. All rights reserved.
//

import UIKit

class WhiteLabel: UILabel {
    
    //修改该属性，即修改了轮廓的颜色
    var outLineColor = UIColor.white
    
    //重写该方法，修改lable文字的描绘方式
    override func drawText(in rect: CGRect) {
        //文字颜色
        let color = textColor
        
        //当前绘制环境
        let context = UIGraphicsGetCurrentContext()
        //设置宽度
        context?.setLineWidth(1)
        //连接处格式
        context?.setLineJoin(.round)
        //设置文字绘制模式为stroke
        context?.setTextDrawingMode(.stroke)
        //设置为白色
        textColor = outLineColor
        //调用父类该方法画文字
        super.drawText(in: rect)
        
        //重新设置绘制模式为fill
        context?.setTextDrawingMode(.fill)
        //设置原本颜色
        textColor = color
        //重新画文字
        super.drawText(in: rect)
    }

}
