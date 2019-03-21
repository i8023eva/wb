//
//  PublishTextView.swift
//  wb
//
//  Created by 李元华 on 2019/3/21.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class PublishTextView: UITextView {

    private lazy var placeHolderLabel: UILabel = UILabel()
    
    // 与 xib 相关联的类添加子控件 coder
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        
        setupSubViews()
    }
    // 处理约束
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupSubViews() {
        addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(15)
        }
        
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        
        placeHolderLabel.text = "发布新微薄"
        
        textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
