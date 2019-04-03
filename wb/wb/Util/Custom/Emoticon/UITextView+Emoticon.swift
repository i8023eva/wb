//
//  UITextView+Emoticon.swift
//  表情键盘
//
//  Created by 李元华 on 2019/4/1.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

extension UITextView {
    /**
        
     */
    func getEmoticonText() -> String {
        
        let attrMuString = NSMutableAttributedString(attributedString: attributedText)
        
        let range = NSRange(location: 0, length: attrMuString.length)
        
        attrMuString.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            
            if let attachment = dict[NSAttributedString.Key.attachment] as? EmoticonAttachment  {
                //                数据不够，自定义类
                attrMuString.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        return attrMuString.string
    }
    
    /**
     
     */
    func insertEmoticonText(emoticon: Emoticon) -> Void {
        
        let session = EmoticonSession(emoticon: emoticon)
        
        if emoticon.isEmpty {return}
        
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        
        if session.code != nil {
            guard let range = selectedTextRange else {return}
            
            replace(range, withText: session.code!)
            return
        }
        
        //        图片 >> 图文混排
        
        let attachment = EmoticonAttachment()
        attachment.image = UIImage(contentsOfFile: session.png ?? "")
        attachment.chs = emoticon.chs
        
        let font = self.font!
        //        FIXME: 光标会跳到最后，之后输入的字会变小
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        
        let attrString = NSAttributedString(attachment: attachment)
        
        let range = selectedRange
        
        let attrMuString = NSMutableAttributedString(attributedString: attributedText)
        
        attrMuString.replaceCharacters(in: range, with: attrString)
        
        attributedText = attrMuString
        //        FIX: 重置字体
        self.font = font
        //        FIX: 设置光标
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
