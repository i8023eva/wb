//
//  HomeTableViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/4.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    var isPresented: Bool = false
    
    
    private lazy var titleBtn : UIButton = TitleButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.addRotationAnimation()
        
        if !isLogin {return}
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(normalImgName: "navigationbar_friendattention",
                                                                highlightedImgName: "navigationbar_friendattention_highlighted")
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(normalImgName: "navigationbar_pop",
                                                                 highlightedImgName: "navigationbar_pop_highlighted")
        titleBtn.setTitle("username", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(btn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    @objc private func titleBtnClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        
        let pop = PopoverViewContoller()
        
        // 弹出视图的样式 custom - 其他设置size、source等无效
        pop.modalPresentationStyle = UIModalPresentationStyle.custom

        pop.transitioningDelegate = self
        
        present(pop, animated: true, completion: nil)
    }
    
    // MARK: 自定义转场
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return EVAPresentationController(presentedViewController: presented, presenting: presenting)
    }
    // MARK: 自定义弹出
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    // MARK: 自定义消失
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
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
