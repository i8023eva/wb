//
//  EVAPresentationController.swift
//  wb
//
//  Created by 李元华 on 2019/3/5.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class EVAPresentationController: UIPresentationController {
    
    private lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
        coverView.frame = containerView!.bounds
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EVAPresentationController.coverViewClick)))
        return coverView
    }()
    
    var presentedFrame: CGRect = CGRect.zero
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView?.frame = presentedFrame
        setupCoverView()
    }
    
    private func setupCoverView() {
        containerView?.insertSubview(coverView, belowSubview: presentedView!)
    }
    
    @objc private func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
