//
//  OAuthViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/7.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    // MARK: WK xib使用必须有个实例
    @IBOutlet weak var webView: WKWebView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        setupWebView()
    }
}

// MARK: - 设置导航栏
extension OAuthViewController {
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(fillBtnClick))
        title = "用户登录"
    }
    
    @objc private func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func fillBtnClick() {
        
        let jsCode = "document.getElementById('userId').value='1009175863@qq.com';"
        
        webView.evaluateJavaScript(jsCode, completionHandler: nil)
    }
}

// MARK: - WKNavigationDelegate
extension OAuthViewController: WKNavigationDelegate {
    
    fileprivate func setupWebView() {
        let request = URLRequest(url:
            URL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)")!)
        
        webView.load(request)
        
        webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SVProgressHUD.show()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    // 准备加载页面
     func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let URL = webView.url else {
            decisionHandler(.allow)
            return
        }
        // http://i8023eva.github.io/?code=5899db13bf2feac60c4278e576c7830f
        let URLString = URL.absoluteString
        
        guard URLString.contains("code=") else {
        
            decisionHandler(.allow)
            return
        }
        
        let code = URLString.components(separatedBy: "code=").last!
        
        accessToken(code: code)
        
        decisionHandler(.cancel)
    }
    /// 获取授权过的Access Token
    private func accessToken(code: String) {
        NetworkingManager.shared.loadAccessToken(code: code) { (data, error) in
            if error != nil {
                print("\(#line)---\(error!)")
                return
            }
            
            guard let infoDict = data else {
                return
            }
            
            self.userInfo(infoDict: infoDict)
        }
    }
    /// 根据 token 获取用户信息
    private func userInfo(infoDict: [String : AnyObject]) {
        let user = UserAccount(dict: infoDict)
        
        NetworkingManager.shared.loadUserInfo(user: user, completion: { (data, error) in
            if error != nil {
                EVALog(message: "")
                return
            }
            guard let userInfoDict = data else {
                return
            }
            user.screen_name = userInfoDict["screen_name"] as? String
            user.avatar_large = userInfoDict["avatar_large"] as? String
            
            UserSession.shared.saveFile(user: user)

            // FIXME: 初次登录  saveFile 单例的 user 还是空，重新赋值
            self.dismiss(animated: false, completion: {
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
        })
    }
}
