//
//  PublishViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/21.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

class PublishViewController: UIViewController {
    
    @IBOutlet weak var publishTextView: PublishTextView!
    
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    
    private lazy var titleView: PublishTitleView = PublishTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
//        键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(PublishViewController.keyboardWillChangeFrame(note:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        publishTextView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - NotificationCenter
extension PublishViewController {
    
    @objc private func keyboardWillChangeFrame(note: Notification) {
//        UIKeyboardAnimationDurationUserInfoKey
//        UIKeyboardFrameEndUserInfoKey
        
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let endFrame = note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
//        (0.0, 477.0, 375.0, 335.0)
//        (0.0, 812.0, 375.0, 335.0)
        let distance = UIScreen.main.bounds.height - endFrame.origin.y
        
        let name = UIDevice.current.name
        if name == "iPhone X" || name == "iPhone XR" || name == "iPhone XS Max" {
            if distance != 0 {
                toolBarBottomCons.constant = -distance + 34
            } else {
                toolBarBottomCons.constant = -distance
            }
            
        } else {
            toolBarBottomCons.constant = -distance
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextViewDelegate
extension PublishViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        publishTextView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        publishTextView.resignFirstResponder()
    }
}

// MARK: - Navigation
extension PublishViewController {
    
    private func setupNav() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(PublishViewController.cancelBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(PublishViewController.publishBtnClick))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.titleView = titleView
    }
    
    @objc private func cancelBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func publishBtnClick() {
        
    }
}

