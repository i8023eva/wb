//
//  PublishTitleView.swift
//  wb
//
//  Created by 李元华 on 2019/3/21.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit
import SnapKit

class PublishTitleView: UIView {
    
    private lazy var titleLabel: UILabel = UILabel()
    private lazy var screenNameLabel: UILabel = UILabel()

    // 设置子控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.darkGray
        
        titleLabel.text = "发微博"
        screenNameLabel.text = UserSession.shared.user?.screen_name
    }
}
