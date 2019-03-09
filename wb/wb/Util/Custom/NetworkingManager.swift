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
    static let share: NetworkingManager = {
        let manager = NetworkingManager()
        manager.responseSerializer.acceptableContentTypes?.insert("text/html")
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

extension NetworkingManager {
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
        NetworkingManager.share.request(requestType: .POST, URLString: "https://api.weibo.com/oauth2/access_token", parameters: parameters as [String : AnyObject]) { (data, error) in
            completion(data as? [String : AnyObject], error)
        }
    }
}
