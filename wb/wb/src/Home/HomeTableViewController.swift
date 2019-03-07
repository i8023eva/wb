//
//  HomeTableViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/4.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    // 两种情况需要self。 函数中有歧义； 闭包
    private lazy var animatedTransition: AnimatedTransition = AnimatedTransition {[weak self] (status) in
        self?.titleBtn.isSelected = status
    }
    
    private lazy var titleBtn : UIButton = TitleButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.addRotationAnimation()
        
        if !isLogin {return}
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(normalImgName: "navigationbar_friendattention",
                                                                highlightedImgName: "navigationbar_friendattention_highlighted")
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(normalImgName: "navigationbar_pop",
                                                                 highlightedImgName: "navigationbar_pop_highlighted")
        titleBtn.setTitle("username", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(btn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    @objc private func titleBtnClick(btn: UIButton) {
//        btn.isSelected = !btn.isSelected
        
        let pop = PopoverViewContoller()
        
        // 弹出视图的样式 custom - 其他设置size、source等无效
        pop.modalPresentationStyle = UIModalPresentationStyle.custom

        pop.transitioningDelegate = animatedTransition  //一个遵守协议的对象
        
        let width: CGFloat = 150.0
        let y: CGFloat = UIApplication.shared.statusBarFrame.height + 44 - 10
        animatedTransition.presentedFrame = CGRect(x: UIScreen.main.bounds.width * 0.5 - width * 0.5, y: y, width: width, height: 200)
        
        present(pop, animated: true, completion: nil)
    }
    
    
}
