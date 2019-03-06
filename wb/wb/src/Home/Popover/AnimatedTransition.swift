//
//  AnimatedTransition.swift
//  wb
//
//  Created by 李元华 on 2019/3/6.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class AnimatedTransition: NSObject {

    var isPresented: Bool = false  // 按钮状态
    var presentedFrame:CGRect = CGRect.zero
    var sendStatus: ((_ status: Bool) -> ())?
    
    // 注意:如果自定义了一个构造函数,但是没有对默认构造函数init()进行重写,那么自定义的构造函数会覆盖默认的init()构造函数
    init(sendStatus: @escaping (_ status: Bool) -> ()) {
        self.sendStatus = sendStatus
    }
}

extension AnimatedTransition: UIViewControllerTransitioningDelegate,
                              UIViewControllerAnimatedTransitioning {
    // MARK: - UIViewControllerTransitioningDelegate自定义转场
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentedController = EVAPresentationController(presentedViewController: presented, presenting: presenting)
        
        presentedController.presentedFrame = presentedFrame
        
        return presentedController
    }
    // MARK: 弹出
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        
        sendStatus!(isPresented)
        return self  //遵守协议的对象
    }
    // MARK: 消失
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        
        sendStatus!(isPresented)
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning 自定义转场动画
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // transitionContext: 转场上下文
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? presentedAnimation(transitionContext: transitionContext) : dismissedAnimation(transitionContext: transitionContext)
    }
    
    private func presentedAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        transitionContext.containerView.addSubview(presentedView!)
        
        presentedView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0)
        presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView?.transform = CGAffineTransform.identity
        }) { (_) in
            // 结束之后通知上下文
            transitionContext.completeTransition(true)
        }
    }
    
    private func dismissedAnimation(transitionContext: UIViewControllerContextTransitioning) {
        let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissedView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
        }) { (_) in
            
            dismissedView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
    }
}
