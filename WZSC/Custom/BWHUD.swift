//
//  BWHUD.swift
//  BWSmarterLifeV4
//
//  Created by yuhua on 2019/3/19.
//  Copyright © 2019 余华. All rights reserved.
//

import Foundation
import SVProgressHUD

class BWHUD {
    
    static var timer: Timer?
    
    ///弹出HUD，指定时间过后，会消失
    static func showHUD(msg: String? = nil, delay: TimeInterval = 8, maskType: SVProgressHUDMaskType = .black, delayBlock: (()->Void)? = nil) {
        SVProgressHUD.setDefaultMaskType(maskType)
        SVProgressHUD.setForegroundColor(CustomColor.mainColor)
        if let title = msg {
            SVProgressHUD.show(withStatus: title)
        }else {
            SVProgressHUD.show()
        }
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(delayHUD), userInfo: delayBlock, repeats: false)
    }
    
    /// 延时执行
    @objc static func delayHUD() {
        if let block = timer?.userInfo, let closure = block as? ()->Void {
            closure()
        }
        timer?.invalidate()
        timer = nil
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.showError(withStatus: "操作延时，请重试！")
    }
    
    ///弹出成功的HUD
    static func successHUD(msg: String = "操作成功！", maskType: SVProgressHUDMaskType = .black) {
        timer?.invalidate()
        timer = nil
        SVProgressHUD.setDefaultMaskType(maskType)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.showSuccess(withStatus: msg)
    }
    
    ///弹出信息HUD
    static func infoHUD(msg: String, maskType: SVProgressHUDMaskType = .black) {
        timer?.invalidate()
        timer = nil
        SVProgressHUD.setDefaultMaskType(maskType)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        SVProgressHUD.showInfo(withStatus: msg)
    }
    
    /// 使HUD消失
    static func dismissHUD() {
        timer?.invalidate()
        timer = nil
        SVProgressHUD.dismiss()
    }
}

