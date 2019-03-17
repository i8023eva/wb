//
//  WelcomeViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/10.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    @IBOutlet weak var iconBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        iconView.layer.cornerRadius = 45
//        iconView.layer.masksToBounds = true
        
        let iconURLString = UserSession.shared.user?.avatar_large
        
        // ?? : 如果??前面的可选类型有值,那么将前面的可选类型进行解包并且赋值
        // 如果??前面的可选类型为nil,那么直接使用??后面的值
        iconView .sd_setImage(with: URL(string: iconURLString ?? ""), placeholderImage: UIImage(named: "avatar_default_big"))

        iconBottomConstraint.constant = UIScreen.main.bounds.height * 0.5
        
        // Damping : 阻力系数,阻力系数越大,弹动的效果越不明显 0~1
        // initialSpringVelocity : 初始化速度
        UIView.animate(withDuration: 2.1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1.1, delay: 0.1, options: .curveEaseInOut, animations: {
                self.view.alpha = 0.7
                self.view.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
//                let trsation = CATransition()
//                trsation.type = .reveal
//                trsation.subtype = .fromBottom
//                self.view.layer.add(trsation, forKey: nil)
                
            }) { (finished) in
                UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            }
           
        }
    }
}
