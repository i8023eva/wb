//
//  EmoticonManager.swift
//  表情键盘
//
//  Created by 李元华 on 2019/3/25.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class EmoticonManager {
    
    var packageArr: [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        // 最近
        packageArr.append(EmoticonPackage(id: ""))
//        默认
        packageArr.append(EmoticonPackage(id: "com.sina.default"))
//        emoji
        packageArr.append(EmoticonPackage(id: "com.apple.emoji"))
//        浪小花
        packageArr.append(EmoticonPackage(id: "com.sina.lxh"))
    }
}
