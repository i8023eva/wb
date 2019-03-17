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
    @objc var created_at: String? {
        didSet {
            guard let created_at = created_at else { return }
            
            createdAtReplace = Date.manageCreatedString(createdString: created_at)
        }
    }
    /// 微博信息内容
    @objc var text: String?
    /// 微博来源   <a href="http://weibo.com/" rel="nofollow">小南的iPhone客户端</a>
    @objc var source: String? {
        didSet {
            guard let source = source, source != "" else { return }
            
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            
            sourceReplace = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
    }
    /// 微博MID
    @objc var mid: Int64 = 0
    
    /// 微博创建时间替换属性
    var createdAtReplace: String?
    /// 微博来源替换属性
    var sourceReplace: String?
    
    
    
    init(dict: [String : AnyObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
