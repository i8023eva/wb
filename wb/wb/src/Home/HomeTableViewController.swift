//
//  HomeTableViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/4.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    // 两种情况需要self。 函数中有歧义； 闭包
    private lazy var animatedTransition: AnimatedTransition = AnimatedTransition {[weak self] (status) in
        self?.titleBtn.isSelected = status
    }
    
    private lazy var titleBtn: TitleButton = TitleButton()
    
    private lazy var statusSessionArr: [StatusSession] = [StatusSession]()

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.addRotationAnimation()
        
        if !isLogin {return}
        
        setupNavBar()
        
        loadHomeInfo()
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    

}

// MARK: - delegate & datasource
extension HomeTableViewController{
    
    private func loadHomeInfo() {
        NetworkingManager.shared.loadHomeInfo { (statuses, error) in
            
            if error != nil {
                EVALog(message: error)
                return
            }
            guard let dataArr = statuses else {
                return
            }
            for dataDict in dataArr {
                let status = Status(dict: dataDict)
                self.statusSessionArr.append(StatusSession(status: status))
            }
//            print(Thread.current)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusSessionArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeTableViewCell
        
        cell.statusSession = statusSessionArr[indexPath.row]
        
        return cell
    }
}
// MARK: -  navigationItem
extension HomeTableViewController{
    
    private func setupNavBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(normalImgName: "navigationbar_friendattention",
                                                                highlightedImgName: "navigationbar_friendattention_highlighted")
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(normalImgName: "navigationbar_pop",
                                                                 highlightedImgName: "navigationbar_pop_highlighted")
        titleBtn.setTitle(UserSession.shared.user?.screen_name, for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick(btn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    @objc private func titleBtnClick(btn: UIButton) {
        //        btn.isSelected = !btn.isSelected
        
        let pop = PopoverViewContoller()
        
        // 弹出视图的样式 custom - 其他设置size、source等无效
        pop.modalPresentationStyle = UIModalPresentationStyle.custom
        
        pop.transitioningDelegate = animatedTransition  //一个遵守协议的对象
        
        let width: CGFloat = 150.0
        let y: CGFloat = UIApplication.shared.statusBarFrame.height + 44 - 10
        animatedTransition.presentedFrame = CGRect(x: UIScreen.main.bounds.width * 0.5 - width * 0.5, y: y, width: width, height: 200)
        
        present(pop, animated: true, completion: nil)
    }
}
