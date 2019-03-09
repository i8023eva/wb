//
//  UserAccount.swift
//  wb
//
//  Created by 李元华 on 2019/3/9.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class UserAccount: NSObject {
/*
    "access_token": "ACCESS_TOKEN",
    "expires_in": 1234,
     isRealName = true,
    "remind_in":"798114", 该参数即将废弃，开发者请使用expires_in
    "uid":"12341234"
*/
    /// 授权AccessToken
    @objc var access_token : String?
    /// 过期时间-->秒
    @objc var expires_in : TimeInterval = 0.0 {
        didSet {
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    /// 格式化时间
    @objc var expires_date : Date?
    /// 用户ID
    @objc var uid : String?
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        // 对象转字典
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid"]).description
    }
}
