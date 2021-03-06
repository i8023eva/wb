//
//  Common.swift
//  wb
//
//  Created by 李元华 on 2019/3/7.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

/// 申请应用时分配的AppKey
let client_id: String = "4023078902"
/// 申请应用时分配的AppSecret。
let client_secret: String = "16362eaa799dbcf8296ea9beb90cb255"
/// 授权回调地址
let redirect_uri: String = "http://i8023eva.github.io"
/// 请求的类型，填写authorization_code
let grant_type: String = "authorization_code"

/// 沙盒
let DocumentPath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
///
let userInfo: String = "UserInfo.plist"

let navHeight: CGFloat = 44

let MainWidth = UIScreen.main.bounds.width
let MainHeight = UIScreen.main.bounds.height


/// 键盘图片选择通知
let PicPickerCellAddNotification: NSNotification.Name = NSNotification.Name(rawValue: "PicPickerCellAddNotification")
/// 键盘图片选择通知
let PicPickerCellRemoveNotification: NSNotification.Name = NSNotification.Name(rawValue: "PicPickerCellRemoveNotification")

/// 显示图片浏览器
let ShowPhotoBrowserNotification: Notification.Name = Notification.Name("ShowPhotoBrowserNotification")
let PhotoIndexPathKey = "PhotoIndexPath"
let PhotoURLArrKey = "PhotoURLArr"

extension Selector {
    
}

// Build Setting - 搜索 swift flag - 添加 -D DEBUG
// FIXME: 默认参数- ((#file as NSString).lastPathComponent) 会一直打印AppDelegate
/// 自定义打印
func EVALog<T>(message: T, fileName: String = #file, line: Int = #line) {
    
    #if DEBUG
    let fileName = (fileName as NSString).lastPathComponent
    print("- [\(fileName)]\n  \(line)| - \(message)")
    #endif
}


