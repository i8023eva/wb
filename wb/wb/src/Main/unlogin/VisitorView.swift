//
//  VisitorView.swift
//  wb
//
//  Created by 李元华 on 2019/3/4.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    /// 快速创建的类方法
    class func initView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }

    /// 设置控件属性
    func setupView(iconName: String, tip: String) {
        
        iconView.image = UIImage(named: iconName)
        tipLabel.text = tip
        rotationView.isHidden = true
    }
    
    /// 添加转盘动画
    func addRotationAnimation() {

        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.repeatCount = MAXFLOAT
        animation.duration = 5.5
        animation.isRemovedOnCompletion = false // 动画不会被删除
        
        rotationView.layer.add(animation, forKey: nil)
    }

}
