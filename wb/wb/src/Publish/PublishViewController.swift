//
//  PublishViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/21.
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit
import SVProgressHUD

class PublishViewController: UIViewController {
    
    @IBOutlet weak var publishTextView: PublishTextView!
    @IBOutlet weak var picPickerCollectionView: PicPickerCollectionView!
    
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHeight: NSLayoutConstraint!
    
    private lazy var titleView: PublishTitleView = PublishTitleView()
    private lazy var pickImagesArr: [UIImage] = [UIImage]()
    
    private lazy var emoticonVC: EmoticonViewController = EmoticonViewController {[weak self] (emoticon) in
        self?.publishTextView.insertEmoticonText(emoticon: emoticon)
        self?.textViewDidChange(self!.publishTextView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        addNotification()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        publishTextView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}

// MARK: - toolBar click
extension PublishViewController {
    /// 弹出图片选择
    @IBAction func picBtnClick(_ sender: Any) {
        publishTextView.resignFirstResponder()
        
        picPickerViewHeight.constant = UIScreen.main.bounds.height * 0.62
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    /// 弹出表情键盘
    @IBAction func emoticonBtnClick(_ sender: UIButton) {
//        print(publishTextView.inputView)  nil  就是系统键盘
        publishTextView.resignFirstResponder()
        
        publishTextView.inputView = publishTextView.inputView != nil ? nil : emoticonVC.view
        
        publishTextView.becomeFirstResponder()
    }
}

// MARK: - NotificationCenter
extension PublishViewController {
    
    private func addNotification() {
        //        键盘弹出通知
        NotificationCenter.default.addObserver(self, selector: #selector(PublishViewController.keyboardWillChangeFrame(note:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // 图片选择点击
        NotificationCenter.default.addObserver(self, selector: #selector(PublishViewController.picPickerCellAdd), name: PicPickerCellAddNotification, object: nil)
        
        // 图片删除点击
        NotificationCenter.default.addObserver(self, selector: #selector(PublishViewController.picPickerCellRemove(note:)), name: PicPickerCellRemoveNotification, object: nil)
    }
    // index cell 的图片
    @objc private func picPickerCellRemove(note: Notification) {
        
        guard let image = note.object as? UIImage else {return}
        
        guard let index = pickImagesArr.firstIndex(of: image) else {return}
        
        pickImagesArr.remove(at: index)
        
        picPickerCollectionView.pickImagesArr = pickImagesArr
    }
    // 获取图片库
    @objc private func picPickerCellAdd() {
//        判断数据源
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) { return }
        
        let imgPicker = UIImagePickerController()
        
        imgPicker.sourceType = .photoLibrary
        
        imgPicker.delegate = self
        
        present(imgPicker, animated: true, completion: nil)
        
    }
    
    /// toolBar 跟随键盘移动
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

// MARK: - UIImagePickerControllerDelegate
extension PublishViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    选择图片之后
    // FIXME: [discovery] errors
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        pickImagesArr.append(image)
        
        picPickerCollectionView.pickImagesArr = pickImagesArr
        
        picker.dismiss(animated: true, completion: nil)
        
        publishTextView.resignFirstResponder()
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
        publishTextView.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func publishBtnClick() {

        let statusText = publishTextView.getEmoticonText()
        
        let finishHandle = { (isSuccess: Bool) -> () in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "发送失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "发送成功")
            self.dismiss(animated: true, completion: nil)
        }
        
        if pickImagesArr.first != nil {
            NetworkingManager.shared.uploadStatus(statusText: statusText, imageArr: pickImagesArr, completion: finishHandle)
        } else {
            NetworkingManager.shared.updateStatus(statusText: statusText, completion: finishHandle)
        }
    }
}

