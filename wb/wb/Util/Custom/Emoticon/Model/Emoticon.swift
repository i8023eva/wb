//
//  Emoticon.swift
//  表情键盘
//
//  Created by 李元华 on 2019/3/25.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class Emoticon: NSObject {

    /// emoji的code
    @objc var code: String?
    /// 普通表情对应的图片名称
    @objc var png: String?
    /// 普通表情对应的文字
    @objc var chs: String?
    
    /// 删除按钮
    var isRemove: Bool = false
    /// 空白按钮
    var isEmpty: Bool = false
    
    
    init(dict: [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    init(isRemove: Bool) {
        self.isRemove = isRemove
    }
    
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {    }
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["code", "png", "chs"]).description
    }
}
