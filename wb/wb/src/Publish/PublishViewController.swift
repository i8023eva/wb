//
//  PublishViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/21.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController {
    
    private lazy var titleView: PublishTitleView = PublishTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
    }
}

extension PublishViewController {
    
    private func setupNav() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(PublishViewController.cancelBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(PublishViewController.publishBtnClick))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.titleView = titleView
    }
    
    @objc private func cancelBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func publishBtnClick() {
        
    }
}

