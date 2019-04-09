//
//  HomeTableViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/4.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeTableViewController: BaseTableViewController {
    
    // 两种情况需要self。 函数中有歧义； 闭包
    private lazy var animatedTransition: AnimatedTransition = AnimatedTransition {[weak self] (status) in
        self?.titleBtn.isSelected = status
    }
    
    private lazy var titleBtn: TitleButton = TitleButton()
    
    private lazy var statusSessionArr: [StatusSession] = [StatusSession]()
    
    private lazy var tipLabel: UILabel  = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: navHeight - 44, width: UIScreen.main.bounds.width, height: 44)
        label.backgroundColor = UIColor.orange
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.isHidden = true
        
        navigationController?.navigationBar.insertSubview(label, at: 0)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.addRotationAnimation()
        
        if !isLogin {return}
        
        setupNavBar()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        setupHeaderView()
        setupFooterView()
        
        addNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 数据
extension HomeTableViewController {
    
    @objc private func loadNewStatus() {
        loadHomeInfo(isNewData: true)
    }
    @objc private func loadOldStatus() {
        loadHomeInfo(isNewData: false)
    }
    
    private func loadHomeInfo(isNewData: Bool) {
        var since_id = 0
        var max_id = 0   // 小于或**等于**
        
        if isNewData {
            since_id = statusSessionArr.first?.status?.mid ?? 0
        } else {
            max_id = statusSessionArr.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        NetworkingManager.shared.loadHomeInfo(sinceID: since_id, maxID: max_id) { (statuses, error) in
            if error != nil {
                EVALog(message: error)
                return
            }
            guard let dataArr = statuses else {
                return
            }
            
            // 新数据应该在上面
            var tempArr = [StatusSession]()
            for dataDict in dataArr {
                let status = Status(dict: dataDict)
                tempArr.append(StatusSession(status: status))
            }
            
            if isNewData {
                self.statusSessionArr = tempArr + self.statusSessionArr
            } else {
                self.statusSessionArr = self.statusSessionArr + tempArr
            }
            
            //            print(Thread.current)
            self.cacheImage(sessionArr: tempArr)
        }
    }
    
    private func cacheImage(sessionArr: [StatusSession]) {
        //        加入同一组 同步执行
        let group = DispatchGroup()
        
        for session in sessionArr {
            for picUrl in session.picURLsReplace {
                group.enter()
                SDWebImageManager.shared.imageLoader.requestImage(with: picUrl, options: [], context: nil, progress: nil) { (_, _, _, _) in
                    //                    EVALog(message: "下载图片")
                    group.leave()
                }
//                downloadImage(with: picUrl, options: [], progress: nil, completed: { (_, _, _, _) in
//                    //                    EVALog(message: "下载图片")
//                    group.leave()
//                })
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            //            EVALog(message: "刷新表格")
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.showTipLabel(count: sessionArr.count)
        }
    }
    
    private func showTipLabel(count: Int) {
        tipLabel.isHidden = false
        tipLabel.text = (count == 0 ? "没有🆕" : "\(count) 条微博")

        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.frame.origin.y = navHeight
        }) { (_) in

            UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
                self.tipLabel.frame.origin.y = navHeight - 44
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
}

// MARK: - delegate & datasource
extension HomeTableViewController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusSessionArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeTableViewCell
        
        cell.statusSession = statusSessionArr[indexPath.row]
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return statusSessionArr[indexPath.row].cellHight
//    }
}
// MARK: -  UI
extension HomeTableViewController{
    
    private func setupHeaderView() {
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.loadNewStatus))
        
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("松开刷新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
    }
    
    private func setupFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.loadOldStatus))
    }
    
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

extension HomeTableViewController {
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser(note:)), name: ShowPhotoBrowserNotification, object: nil)
    }
    
    @objc private func showPhotoBrowser(note: Notification) {
        
        let indexPath = note.userInfo?[PhotoIndexPathKey]
        let photoURLArr = note.userInfo?[PhotoURLArrKey]
        
        present(PhotoBrowserViewController(indexPath: indexPath as! IndexPath, picURLArr: photoURLArr as! [URL]), animated: true, completion: nil)
    }
}
