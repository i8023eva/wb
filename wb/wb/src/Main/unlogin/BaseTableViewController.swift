//
//  BaseTableViewController.swift
//  wb
//
//  Created by 李元华 on 2019/3/4.
//  Copyright © 2019年 李元华. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    lazy var visitorView: VisitorView = VisitorView.initView()
    
    override func loadView() {
        isLogin ? super.loadView() : setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavItem()
    }
    
    private func setupView() {
        view = visitorView
        visitorView.registerBtn.addTarget(self,
                                          action: #selector(BaseTableViewController.registerBtnClick),
                                          for: .touchUpInside)
        visitorView.loginBtn.addTarget(self,
                                       action: #selector(BaseTableViewController.loginBtnClick),
                                       for: .touchUpInside)
    }
    
    private func setupNavItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(BaseTableViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(BaseTableViewController.loginBtnClick))
    }
    
    @objc private func registerBtnClick() {
        print(#function)
    }
    
    @objc private func loginBtnClick() {
        
        let oaVC = UINavigationController(rootViewController: OAuthViewController())
        // FIXME: Snapshotting
        oaVC.modalPresentationStyle = UIModalPresentationStyle.currentContext
        
        self.present(oaVC, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
