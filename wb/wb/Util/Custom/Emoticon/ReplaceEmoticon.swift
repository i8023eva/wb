//
//  ReplaceEmoticon.swift
//  wb
//
//  Created by 李元华 on 2019/4/4.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class ReplaceEmoticon: NSObject {

    static let shared: ReplaceEmoticon = ReplaceEmoticon()
    
    private lazy var manager: EmoticonManager = EmoticonManager()
    
    func replaceAttrString(statusText: String?, font: UIFont) -> NSMutableAttributedString? {
        
        guard let statusText = statusText else { return nil }
        
        let pattern = #"\[.*?\]"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return nil }
        
        let resultArr = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.count))
        
        let attrMuString = NSMutableAttributedString(string: statusText)
        
        for result in resultArr.reversed() {
            
            let chs = String(statusText[statusText.range(from: result.range)!])
//            新表情没有, 返回原始
            guard let imagePath = findPath(chs: chs) else {
                return attrMuString
            }
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: imagePath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrString = NSAttributedString(attachment: attachment)
            
            attrMuString.replaceCharacters(in: result.range, with: attrString)
        }
        return attrMuString
    }
    
    private func findPath(chs: String) -> String? {
        
        for package in manager.packageArr {
            for emoticon in package.emoticonArr {
                if emoticon.chs == chs {
                    return EmoticonSession(emoticon: emoticon).png
                }
            }
        }
        
        return nil
    }
}
