//
//  MainViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/4.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    private lazy var publishBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishBtn.setImage(UIImage(named: "tabbar_compose_icon_add"),
                            for: UIControl.State.normal)
        publishBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"),
                            for: UIControl.State.highlighted)
        publishBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"),
                                      for: UIControl.State.normal)
        publishBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"),
                                      for: UIControl.State.highlighted)
        publishBtn.sizeToFit()
        publishBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        tabBar .addSubview(publishBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: 在viewDidLoad 中设置tabBar.items会被重新设置
    }

}
