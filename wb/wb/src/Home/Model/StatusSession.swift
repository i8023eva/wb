//
//  StatusSession.swift
//  wb
//
//  Created by 李元华 on 2019/3/18.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

/// Status 数据管理
class StatusSession: NSObject {

    var status: Status?
    // 不设置 toolbar 下边距， 自己计算高度   ;2. 从上到下设置好约束 Content Hugging Priority
//    var cellHight: CGFloat = 0
    
    
    /// 微博创建时间替换属性
    var createdAtReplace: String?
    /// 微博来源替换属性
    var sourceReplace: String?
    /// 微博配图替换属性
    var picURLsReplace: [URL] = [URL]()
    
    /// 微博认证替换属性
    var verifiedTypeReplace: UIImage?
    /// 会员等级替换属性
    var mbrankReplace: UIImage?
    /// 用户头像地址替换属性
    var profileImgURLReplace: URL?
    
    
    
    init(status: Status) {
        self.status = status

        if let created_at = status.created_at {
            createdAtReplace = Date.manageCreatedString(createdString: created_at)
        }
                
        if let source = status.source, status.source != ""  {
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
            sourceReplace = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
//        status.pic_urls?.count == 0   status.retweeted_status != nil
        let picURLsArr = status.pic_urls?.count == 0 ? status.retweeted_status?.pic_urls : status.pic_urls
        if let picURLsArr = picURLsArr {
            for picURLDict in picURLsArr {
                guard let picURLString = picURLDict["thumbnail_pic"] else {continue}
                
                picURLsReplace.append(URL(string: picURLString)!)
            }
        }
        
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedTypeReplace = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedTypeReplace = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedTypeReplace = UIImage(named: "avatar_grassroot")
        default:
            verifiedTypeReplace = nil
        }

        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            mbrankReplace = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        
        let profileImgURL = status.user?.profile_image_url ?? ""
        profileImgURLReplace = URL(string: profileImgURL)
    }
}
