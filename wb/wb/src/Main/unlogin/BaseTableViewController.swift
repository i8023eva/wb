//
//  BaseTableViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/4.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    lazy var visitorView: VisitorView = VisitorView.initView()
    
    /// 是否登录 子类
    var isLogin: Bool = UserSession.shared.isLogin
    
    override func loadView() {
        isLogin ? super.loadView() : setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavItem()
    }
}

extension BaseTableViewController {
    
    private func setupView() {
        view = visitorView
        visitorView.registerBtn.addTarget(self,
                                          action: #selector(BaseTableViewController.registerBtnClick),
                                          for: .touchUpInside)
        visitorView.loginBtn.addTarget(self,
                                       action: #selector(BaseTableViewController.loginBtnClick),
                                       for: .touchUpInside)
    }
    
    private func setupNavItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(BaseTableViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(BaseTableViewController.loginBtnClick))
    }
    
    @objc private func registerBtnClick() {
        print(#function)
    }
    
    @objc private func loginBtnClick() {
        
        let oaVC = UINavigationController(rootViewController: OAuthViewController())
        // FIXME: Snapshotting
        oaVC.modalPresentationStyle = UIModalPresentationStyle.currentContext
        
        self.present(oaVC, animated: true, completion: nil)
    }
}
