//
//  EmoticonSession.swift
//  表情键盘
//
//  Created by 李元华 on 2019/3/25.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class EmoticonSession {
    
    var emoticon: Emoticon?

    /// emoji的code
    var code: String?
    /// 普通表情对应的图片名称
    var png: String?
    
    init(emoticon: Emoticon) {
        self.emoticon = emoticon
        
//        emoji 表情解析
        if let code = emoticon.code {
//            创建扫描器
            let scanner = Scanner(string: code)
//            0x  十六进制
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
//            转成字符
            let char = Character(Unicode.Scalar(result)!)
//
            self.code = String(char)
        }
        
//        拼接路径   少了个包名 -》EmoticonPackage
        if let png = emoticon.png {
            self.png = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    

}
