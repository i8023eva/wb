//
//  EmoticonPackage.swift
//  表情键盘
//
//  Created by 李元华 on 2019/3/25.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class EmoticonPackage {

    var emoticonArr: [Emoticon] = [Emoticon]()
    
    init(id: String) {
        
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        
        guard let filePath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle") else {
            return
        }
        
        let arr = NSArray(contentsOfFile: filePath) as! [[String : String]]
        
        var index = 0
        
        for var dict in arr {
            if let png = dict["png"] {
                dict["png"] = "\(id)/\(png)"
            }
            
            emoticonArr.append(Emoticon(dict: dict))
            
            index += 1
            if index == 20 {
                emoticonArr.append(Emoticon(isRemove: true))
                
                index = 0
            }
        }
        
        addEmptyEmoticon(isRecently: false)
    }
    
    private func addEmptyEmoticon(isRecently: Bool) {
        
        let count = emoticonArr.count % 21
        
        if count == 0 && !isRecently { return }
        
        for _ in count..<20 {
            emoticonArr.append(Emoticon(isEmpty: true))
        }
        
        emoticonArr.append(Emoticon(isRemove: true))
    }
}
