//
//  PhotoBrowserModalTransition.swift
/*
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$$$$$$$P"   .   ^*$$$$$$$"       "*$$$$$$$$$$$
$$$$$$$P  e$$$$$$$e  *$$$" z$$$$$$$e  *$$$$$$$$$
$$$$$$F d$$$$$$$$$$$k 4$ :$$$$$$$$$$$k ?$$$$$$$$
$$$$$E d$$$$$$$$$$$$$k  :$$$$$$$$$$$$$k 9$$$$$$$
$$$$$> $$$$$$$$$F  ^$$  $$" ^$$$$$$$$$$>'$$$$$$$
$$$$$>'$$$$$$$$E    '$> $>   '$$$$$$$$$> $$$$$$$
$$$$$> $$$$$$$$$u  .$$  $N   @$$$$$$$$$~:$$$$$$$
$$$$$$ '$$$$$$$$$$$$$"  '$$$$$$$$$$$$$F 9$$$$$$$
$$$$$$N ^$$$$$$$$$$$" dN '$$$$$$$$$$$"  ^$$$$$$$
$$$$$$  . ^*$$$$$*" .$$$$. ^*$$$$$$"  @$L "$$$$$
$$$$$ .$$$e.     .e$$$$$$$$c.      u@$$$$& ?$$$$
$$$$  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"`"$$$K 9$$$
$$$E 3$$F   `$$$$$$$$$$$$$$$$$$$$$$     $$$ '$$$
$$$E 3$$     9$$$$$$$$$$$$$$$$$$$$$     $$$ '$$$
$$$$ ^$$N.  d$$$$$$$$$$$$$$$$$$$$$$$u.u$$$$ J$$$
$$$$L R$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  $$$$
$$$$$r #$$$$$$  ^*$$$$$$$$$$$$# '$$$$$$$$  @$$$$
$$$$$$k '*$$$$$$c  ^*$$$$$*"  .d$$$$$$$" .$$$$$$
$$$$$$$$e    ""*$$$c  ^"  .z$$$$*#"    z$$$$$$$$
$$$$$"   uze  c.                .zc  .   "$$$$$$
$$$" .@$$$$  $$!!!^"*E!!!P" '!!9$$$: 4$$N. ^$$$$
$N.  "$$$$  $$$!!>           !!9$$$!  9$$$$. ?$$
$$$$E @$$  d$$$!!L   .:!:.   !!9$$$!! '$$$$#  ?$
$$$$L   " :9$$$!!!9$$E!!!$$$!!!9$$$!!  $$$ :e@$$
$$$$$$>   !9$$$!!!9$$E!!!$$$!!!9$$$!!>     $$$$$
$$$$$$$E  `*$$$!!!9$$E!!!$$$!!!9$*"    :$$$$$$$$
$$$$$$$$  c.      '^""```"`      .zd$$k 4$$$$$$$
$$$$$$$F J$$$$$$$$$beee -d$$$$$$$$$$$$"  9$$$$$$
$$$$$$$L  "    "*"" '#F  3*"`^"#"     ube$$$$$$$
$$$$$$$$$$$$$$$c.zd$b.  L .e@Weu.@$$$$$$$$$$$$$$
*/
//  Copyright © 2019 李元华. All rights reserved.
//

import UIKit

protocol PhotoBrowserModalTransitionDelegate {
    func startRect(with indexPath: IndexPath?) -> CGRect?
    func endRect(with indexPath: IndexPath?) -> CGRect?
    func animationView(with indexPath: IndexPath?) -> UIImageView?
}

protocol PhotoBrowserDismissTransitionDelegate {
    /// 当前 cell 的 indexPath
    func itemWithIndexPath() -> IndexPath?
    func itemWithImage() -> UIImageView?
}

class PhotoBrowserModalTransition: NSObject, UIViewControllerTransitioningDelegate {
    var modalDelegate: PhotoBrowserModalTransitionDelegate?
    var dismissDelegate: PhotoBrowserDismissTransitionDelegate?
    var indexPath: IndexPath?
    var isPresented: Bool = false
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowserModalTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? presentedAnimateTransition(using: transitionContext) : dismissedAnimateTransition(using: transitionContext)
    }
    /**
     小frame -> 大frame
     主页collectionCell（转换坐标系） ->  大图（按图片）
     */
    private func presentedAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedView =  transitionContext.view(forKey: .to) else {return}
        transitionContext.containerView.addSubview(presentedView)
        
        guard let startRect = modalDelegate?.startRect(with: indexPath) else {return}
        guard let endRect = modalDelegate?.endRect(with: indexPath) else {return}
        guard let imageView = modalDelegate?.animationView(with: indexPath) else {return}
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        transitionContext.containerView.backgroundColor = .black
        presentedView.isHidden = true
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = endRect
        }) { (_) in
            imageView.removeFromSuperview()
            // MARK: - 不然显示两张图片
            presentedView.isHidden = false
            transitionContext.containerView.backgroundColor = .clear
            transitionContext.completeTransition(true)
        }
    }
    
    /**
     indexPath >  图片浏览器的 显示的cell
     */
    private func dismissedAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let dismissedView = transitionContext.view(forKey: .from) else { return }
        dismissedView.removeFromSuperview()
        
        guard let dismissIndexPath = dismissDelegate?.itemWithIndexPath() else { return }
        guard let dismissImageView = dismissDelegate?.itemWithImage() else { return }
        guard let startRect = modalDelegate?.startRect(with: dismissIndexPath) else {return}
        transitionContext.containerView.addSubview(dismissImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissImageView.frame = startRect
        }) { (_) in
            dismissImageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
