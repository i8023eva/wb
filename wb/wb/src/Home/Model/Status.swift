/*
{
    statuses: [
        {
 
        },
    ],
 }
*/

import UIKit

class Status: NSObject {
    /// 微博创建时间  Sun Mar 17 15:14:57 +0800 2019
    @objc var created_at: String?
    /// 微博信息内容
    @objc var text: String?
    /// 微博来源   <a href="http://weibo.com/" rel="nofollow">小南的iPhone客户端</a>
    @objc var source: String? 
    /// 微博MID
    @objc var mid: Int64 = 0
    /// 微博作者的用户信息字段
    @objc var user: User?
    
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
        
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = User(dict: userDict)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
