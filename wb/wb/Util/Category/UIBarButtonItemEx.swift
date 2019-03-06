//
//  UIBarButtonItemEx.swift
//  wb
//
//  Created by 李元华 on 2019/3/5.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    /// 自定义
    convenience init(normalImgName: String, highlightedImgName: String) {
        
        let btn = UIButton(normalImgName: normalImgName, highlightedImgName: highlightedImgName)
        
        self.init(customView: btn)
    }
}
