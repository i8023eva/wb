//
//  UIButtonExtension.swift
//  wb
//
//  Created by 李元华 on 2019/3/4.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

extension UIButton {
    //MARK: convenience 便利构造函数，系统类扩充，调用self.init()
    convenience init(normalImgName: String,
                     highlightedImgName: String,
                     normalBackgroundImgName: String,
                     highlightedBackgroundImgName: String) {
        self.init()
        
        setImage(UIImage(named: normalImgName),
                           for: UIControl.State.normal)
        setImage(UIImage(named: highlightedImgName),
                           for: UIControl.State.highlighted)
        setBackgroundImage(UIImage(named: normalBackgroundImgName),
                                     for: UIControl.State.normal)
        setBackgroundImage(UIImage(named: highlightedBackgroundImgName),
                                     for: UIControl.State.highlighted)
        sizeToFit()
    }
}
