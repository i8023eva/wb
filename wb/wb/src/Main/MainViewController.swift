//
//  MainViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/4.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    private lazy var publishBtn = UIButton(normalImgName: "tabbar_compose_icon_add",
                                      highlightedImgName: "tabbar_compose_icon_add_highlighted",
                                 normalBackgroundImgName: "tabbar_compose_button",
                            highlightedBackgroundImgName: "tabbar_compose_button_highlighted")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        publishBtn.addTarget(self, action: #selector(MainViewController.publishBtnClick),
                             for: UIControl.Event.touchUpInside)
        tabBar.addSubview(publishBtn)
        
        
    }
    
    @objc private func publishBtnClick() {
        print(#line)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: 在viewDidLoad 中设置tabBar.items会被重新设置
    }

}
