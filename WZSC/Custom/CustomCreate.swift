//
//  CustomCreate.swift
//  WZSC
//
//  Created by yuhua on 2019/5/30.
//  Copyright © 2019 余华. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import AMPopTip

extension UIActivityIndicatorView: Placeholder {
    public func add(to imageView: ImageView) {
        imageView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }
    
    public func remove(from imageView: ImageView) {
        removeFromSuperview()
    }
}

class CustomCreate {
    
    static var popTip: PopTip = {
        let pop = PopTip()
        pop.bubbleColor = CustomColor.mainColor
        pop.shouldDismissOnTapOutside = true
        
        return pop
    }()
    
    static func createActivity() -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView(style: .white)
        activity.color = .orange
        activity.startAnimating()
        return activity
    }
    
    static func showItemTips(item: Equip) {
        let width: CGFloat = 5+5+5+60+150
        let image = UIImageView()
        image.kf.setImage(with: URL(string: item.imageUrl), placeholder: CustomCreate.createActivity())
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 18)
        name.textColor = CustomColor.mainColor
        name.text = item.name
        let sale = UILabel()
        sale.font = UIFont.systemFont(ofSize: 12)
        sale.textColor = CustomColor.mainColor
        sale.text = "出售价格:\(item.price)"
        let buy = UILabel()
        buy.font = UIFont.systemFont(ofSize: 12)
        buy.textColor = CustomColor.mainColor
        buy.text = "购买价格:\(item.buy)"
        let des = UITextView()
        des.text = item.des
        des.textColor = CustomColor.mainColor
        des.font = UIFont.systemFont(ofSize: 14)
        des.textContainerInset = .init()
        des.isEditable = false
        des.isSelectable = false
        let desHeight = getTextViewHeight(textView: des, width: width)
        let des2 = UITextView()
        des2.text = item.des2
        des2.textColor = CustomColor.mainColor
        des2.font = UIFont.systemFont(ofSize: 14)
        des2.textContainerInset = .init()
        des2.isEditable = false
        des2.isSelectable = false
        let des2Height = getTextViewHeight(textView: des2, width: width)
        let height: CGFloat = 5+60+10+10+5+desHeight+des2Height
        let custom = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        custom.backgroundColor = .white
        custom.addSubview(image)
        custom.addSubview(name)
        custom.addSubview(sale)
        custom.addSubview(buy)
        custom.addSubview(des)
        custom.addSubview(des2)
        image.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(5)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        name.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(image.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 150, height: 20))
        }
        sale.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom)
            $0.left.equalTo(image.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 150, height: 20))
        }
        buy.snp.makeConstraints {
            $0.top.equalTo(sale.snp.bottom)
            $0.left.equalTo(image.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 150, height: 20))
        }
        des.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.top.equalTo(image.snp.bottom).offset(10)
            $0.height.equalTo(desHeight)
        }
        des2.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.top.equalTo(des.snp.bottom).offset(10)
            $0.height.equalTo(des2Height)
        }
        popTip.show(customView: custom, direction: .none, in: UIApplication.shared.delegate!.window!!, from: UIScreen.main.bounds)
    }
    
    static func getHanZi(type: String) -> String {
        var res: String
        switch type {
        case "yellow":
            res = "蓝色"
        case "red":
            res = "红色"
        case "blue":
            res = "绿色"
        default:
            res = "未知"
        }
        return res
    }
    
    static func showMingTips(ming: Ming) {
        let width: CGFloat = 5+5+5+60+150
        let image = UIImageView()
        image.kf.setImage(with: URL(string: ming.imageUrl), placeholder: CustomCreate.createActivity())
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 18)
        name.textColor = CustomColor.mainColor
        name.text = ming.name
        let sale = UILabel()
        sale.font = UIFont.systemFont(ofSize: 12)
        sale.textColor = CustomColor.mainColor
        sale.text = "颜色:\(getHanZi(type: ming.type))"
        let buy = UILabel()
        buy.font = UIFont.systemFont(ofSize: 12)
        buy.textColor = CustomColor.mainColor
        buy.text = "等级:\(ming.grade)"
        let des = UITextView()
        des.text = ming.des
        des.textColor = CustomColor.mainColor
        des.font = UIFont.systemFont(ofSize: 14)
        des.textContainerInset = .init()
        des.isEditable = false
        des.isSelectable = false
        let desHeight = getTextViewHeight(textView: des, width: width)
        let height: CGFloat = 5+60+10+5+desHeight
        let custom = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        custom.backgroundColor = .white
        custom.addSubview(image)
        custom.addSubview(name)
        custom.addSubview(sale)
        custom.addSubview(buy)
        custom.addSubview(des)
        image.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(5)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        name.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(image.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 150, height: 20))
        }
        sale.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom)
            $0.left.equalTo(image.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 150, height: 20))
        }
        buy.snp.makeConstraints {
            $0.top.equalTo(sale.snp.bottom)
            $0.left.equalTo(image.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 150, height: 20))
        }
        des.snp.makeConstraints {
            $0.left.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.top.equalTo(image.snp.bottom).offset(10)
            $0.height.equalTo(desHeight)
        }
        popTip.show(customView: custom, direction: .none, in: UIApplication.shared.delegate!.window!!, from: UIScreen.main.bounds)
    }
}
