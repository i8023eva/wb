//
//  NetworkingManager.swift
//  Networking
//
//  Created by 李元华 on 2019/3/6.
//  Copyright © 2019年 李元华. All rights reserved.
//

import AFNetworking

enum requestType {
    case GET
    case POST
}

class NetworkingManager: AFHTTPSessionManager {

    // 单例 let- 线程安全
    static let shared: NetworkingManager = {
        let manager = NetworkingManager()
//        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: JSONSerialization.ReadingOptions.allowFragments)
//        manager.requestSerializer = AFJSONRequestSerializer(writingOptions: [])
        manager.responseSerializer.acceptableContentTypes?.insert("text/html")
        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return manager
    }()
}

extension NetworkingManager {
    
    func request(requestType: requestType, URLString: String, parameters: [String : AnyObject], completion:  @escaping (_ data: Any?, _ error: Error?) -> ()) {
        
        let success = { (task: URLSessionDataTask, data: Any?) in
            
            completion(data, nil)
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error) in
            completion(nil, error)
        }
        
        
        if requestType == .GET {

            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)

        } else {

            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}

// MARK: - 封装方法
extension NetworkingManager {
    /// 获取access_token
    func loadAccessToken(code: String, completion: @escaping (_ data: [String : AnyObject]?, _ error: Error?) -> ()) {
        let parameters = [
            "client_id" : client_id,
            "client_secret" : client_secret,
            "grant_type" : grant_type,
            "code" : code,
            "redirect_uri" : redirect_uri
        ]
        
        /*
         {
         "access_token" = "2.00Q3WT1E5b7Q5E6812c6900cZV9z_E";
         "expires_in" = 157679999;
         isRealName = true;
         "remind_in" = 157679999;
         uid = 3967093948;
         }
         */
        NetworkingManager.shared.request(requestType: .POST, URLString: "https://api.weibo.com/oauth2/access_token", parameters: parameters as [String : AnyObject]) { (data, error) in
            completion(data as? [String : AnyObject], error)
        }
    }
    
    /// 获取用户信息
    func loadUserInfo(user: UserAccount, completion: @escaping (_ data: [String : AnyObject]?, _ error: Error?) -> ()) {
        let parameters = [
            "access_token" : user.access_token,
            "uid" : user.uid
        ]
        
        NetworkingManager.shared.request(requestType: .GET, URLString: "https://api.weibo.com/2/users/show.json", parameters: parameters as [String : AnyObject]) { (data, error) in
            completion(data as? [String : AnyObject], error)
        }
    }
//https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html
    /**
     获取当前登录用户及其所关注（授权）用户的最新微博
     
     - Parameter sinceID: 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     - Parameter maxID: 若指定此参数，则返回小于或**等于**max_id的微博，默认为0。
     */
    func loadHomeInfo(sinceID: Int, maxID: Int, completion: @escaping (_ data: [[String : AnyObject]]?,_ error: Error?) -> ()) {
        
        let parameters = [
            "access_token" : UserSession.shared.user?.access_token,
            "since_id" : "\(sinceID)",
            "max_id" : "\(maxID)"
        ]
        
        NetworkingManager.shared.request(requestType: .GET, URLString: "https://api.weibo.com/2/statuses/home_timeline.json", parameters: parameters as [String : AnyObject]) { (data, error) in
            
            guard let dataDict = data as? [String : AnyObject] else {
                completion(nil, error)
                return
            }
            
            completion(dataDict["statuses"] as? [[String : AnyObject]], error)
        }
    }
}

extension NetworkingManager {
    /// 发布一条新微博
    func updateStatus(statusText: String, completion: @escaping (_ isSuccess: Bool) -> ()) -> Void {
        
        let URL = "https://api.weibo.com/2/statuses/share.json"
        let parameters = [
            "access_token" : UserSession.shared.user?.access_token,
            "status" : statusText + " https://i8023eva.wordpress.com"
            //.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        ]
        
        request(requestType: .POST, URLString: URL, parameters: parameters as [String : AnyObject]) { (data, error) in
            if data != nil {
                completion(true)
            } else {
                completion(false)
                EVALog(message: error)
            }
        }
    }
    
    /// 上传图片并发布一条新微博   只使用最后一张图片
    func uploadStatus(statusText: String, imageArr: [UIImage], completion: @escaping (_ isSuccess: Bool) -> ()) -> Void {
        let URL = "https://api.weibo.com/2/statuses/share.json"
        let parameters = [
            "access_token" : UserSession.shared.user?.access_token,
            "status" : statusText + " https://i8023eva.wordpress.com"
            //.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        ]
        requestSerializer.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        post(URL, parameters: parameters, constructingBodyWith: { (AFMultipartFormData) in
            for image in imageArr {
                if let imageData = image.jpegData(compressionQuality: 0.1) {
                    AFMultipartFormData.appendPart(withFileData: imageData, name: "pic", fileName: "\(UUID()).jpeg", mimeType: "image/jpeg")
                }
            }
        }, progress: nil, success: { (_, _) in
            completion(true)
        }) { (_, error) in
            completion(false)
            EVALog(message: error)
        }
        
    }
}
