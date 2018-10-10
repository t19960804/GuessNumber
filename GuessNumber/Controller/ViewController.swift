//
//  ViewController.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/6/2.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
class ViewController: UIViewController{
    @IBOutlet weak var easyModeBtn: UIButton!
    @IBOutlet weak var hardModeBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var regulationBtn: UIButton!
    var easyModelController = EasyModeController()
    let customView = CustomView()
    
    var userNameFromLogIn = String()
    
    let realm = try! Realm()
    var allUserFromRealm: Results<User>?
    var realUser = User()
    
    @IBAction func exitApp(_ sender: UIButton) {
        showAlert()
    }
    @IBAction func regulationBtn(_ sender: UIButton) {
        customView.setUpConstraints_Regulation(with: self.view)
        customView.newCancelBtn.addTarget(self, action: #selector(self.cancelRegulation), for: .touchUpInside)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("userName:\(userNameFromLogIn)")
        
        
    }
    
   
    @objc func cancelRegulation()
    {
        customView.removeConstraints_Regulation()
    }
    func showAlert()
    {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "溫馨提醒",
            message: "確定登出?",
            preferredStyle: .alert)
        
        // 建立[登出]按鈕
        let okAction = UIAlertAction(
            title: "登出",
            style: .destructive,
            handler: {
                (action: UIAlertAction!) -> Void in
                do{
                    try? Auth.auth().signOut()
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    print("LogOut Success")
                }
                catch
                {
                    print(error)
                }
        })
        alertController.addAction(okAction)
        // 建立[返回]按鈕
        let backAction = UIAlertAction(
            title: "返回",
            style: .cancel,
            handler: nil)
        alertController.addAction(backAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoEasyMode"
        {

            let destination = segue.destination as! EasyModeController
            
            destination.currentUser = loadUser(userName: userNameFromLogIn)
        }
        else
        {
            let destination = segue.destination as! HardModeController
            
            destination.currentUser = loadUser(userName: userNameFromLogIn)
        }
    }
    func loadUser(userName: String) -> User
    {
        //將所有儲存在Realm的資料撈出來比對
        allUserFromRealm = realm.objects(User.self)
        for user in allUserFromRealm!
        {
            if userName == user.userName
            {
                realUser = user
                
                
            }
            
            
        }
        return realUser
    }
    
}
