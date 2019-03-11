//
//  UserSession.swift
//  wb
//
//  Created by 李元华 on 2019/3/10.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class UserSession {
    /// 单例
    static let shared: UserSession = UserSession()
    
    var user: UserAccount?
    /// 保存的全路径
    lazy var fullPath: URL = {
        return DocumentPath.appendingPathComponent(userInfo)
    }()
    /// 登录 ？
    var isLogin: Bool {
        if user == nil {
            return false
        }
        guard let loadDate = user?.expires_date else { return false }
        
        return loadDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    
    private init() {
        if isFileExist(fileName: userInfo) {
             loadFile()
        }
       
    }
    
    /// 保存
    func saveFile(user: UserAccount) {
        self.user = user // FIX
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
            try data.write(to: fullPath, options: .atomic)
        } catch {
            EVALog(message: "")
        }
    }
    
    func loadFile() {
        do {
            let userData = try Data(contentsOf: fullPath, options: [])
            guard let loadUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userData) as? UserAccount else {
                EVALog(message: "")
                return
            }
            user = loadUser
        } catch {
            // FIXME: 没登陆过没有UserInfo.plist，  url 无法读取捕获异常, 判断文件是否存在
            EVALog(message: "")
        }
    }
    
    private func isFileExist(fileName: String) -> Bool {
        
        let filePath = DocumentPath.appendingPathComponent(fileName).absoluteString.components(separatedBy: "file://").last!
/*
        let indexFix = filePath.index(filePath.startIndex, offsetBy: 7)
        let subString = filePath[indexFix...]
        print(subString)
*/
        return FileManager.default.fileExists(atPath: filePath)
    }
}
