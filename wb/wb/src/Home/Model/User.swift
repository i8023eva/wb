//
//  User.swift
//  wb
//
//  Created by 李元华 on 2019/3/18.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class User: NSObject {
    /// 用户昵称
    @objc var screen_name: String?
    /// 用户头像地址（中图），50×50像素
    @objc var profile_image_url: String?
    /// 微博认证  -1：没有认证; 0，认证用户; 2,3,5: 企业认证; 220: 达人;
    @objc var verified_type: Int = -1
    /// 会员等级 0-6
    @objc var mbrank: Int = 0
    

    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
