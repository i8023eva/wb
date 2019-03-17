//
//  DateEx.swift
//  wb
//
//  Created by 李元华 on 2019/3/17.
//  Copyright © 2019年 李元华. All rights reserved.
//

import Foundation

extension Date {
    
    /// 管理微博创建时间
    static func manageCreatedString(createdString: String) -> String {
        
        let fmt = DateFormatter()
        
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier:Locale.current.identifier)
        
        //        en_US (current)地区设置的是美国  en_CN
        //        print(Locale.availableIdentifiers)
        
        guard let stringDate = fmt.date(from: createdString) else {
            return ""
        }
        
        //        print(stringDate) // 2019-03-16 07:14:57 +0000
        
        let nowDate = Date()
        
        //        print(nowDate)
        // 都是0时区
        let sinceTime =  Int(nowDate.timeIntervalSince(stringDate))
        
        //        print(sinceTime) // 11466.014953017235
        
        // 刚刚
        if sinceTime < 60 {
            return "刚刚"
        }
        // 59分钟前
        if sinceTime < 60*60 {
             return "\(sinceTime / 60)分钟前"
        }
        // 23小时前
        if sinceTime < 60*60*24 {
            return "\(sinceTime / (60*60))小时前"
        }
        
        let calender = Calendar.current
        
        var formatString: String?
        
        
        // 昨天 15:14
        if calender.isDateInYesterday(stringDate) {
            fmt.dateFormat = "昨天 HH:mm"
            formatString = fmt.string(from: stringDate)
        }
        
        // 一年之内 03-01 15:14
        let compos = calender.dateComponents([Calendar.Component.year], from: stringDate, to: nowDate)
        
        if compos.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            formatString = fmt.string(from: stringDate)
        }
        
        // 超过一年 2015-03-01 15:14
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        formatString = fmt.string(from: stringDate)
        
        return formatString ?? ""
        
        /*
         switch sinceTime {
         case 0..<60:
         print("1")
         case 60..<60*60:
         print("2")
         case 60*60..<60*60*24:
         print("3")
         case 60*60*24..<60*60*24*2:
         print("4")
         case 60*60*24..<60*60*24*365:
         print("5")
         default:
         print("6")
         }
         */
        
    }
}
