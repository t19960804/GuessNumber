//
//  ViewController.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/6/2.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import UIKit
import CountdownLabel
import Firebase
import RealmSwift
class ViewController: UIViewController{
    @IBOutlet weak var easyModeBtn: UIButton!
    @IBOutlet weak var hardModeBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var regulationBtn: UIButton!
    var easyModelController = EasyModeController()
    var pauseView = UIView()
    var cancelBtn = UIButton()
    var regulation = UILabel()
    var userNameFromLogIn = String()
    
    let realm = try! Realm()
    var allUserFromRealm: Results<User>?
    var realUser = User()
    
    @IBAction func exitApp(_ sender: UIButton) {
        showAlert()
    }
    @IBAction func regulationBtn(_ sender: UIButton) {
        let frame = CGRect(x:0,y:20,width:self.view.frame.width,height:self.view.frame.height)
        pauseView = UIView(frame: frame)
        pauseView.backgroundColor = UIColor.black
        pauseView.alpha = 0.5
        self.view.addSubview(pauseView)
        /////////////////////////////////
        let cancelBtnImage = UIImage(named: "cancel.png")
        let cancelBtnframe = CGRect(x:self.view.frame.width - 60,
                                    y:40,
                                    width:(cancelBtnImage?.size.width)!,
                                    height:(cancelBtnImage?.size.height)!)
        cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(cancelBtnImage, for: .normal)
        cancelBtn.frame = cancelBtnframe
        cancelBtn.addTarget(self, action: #selector(self.cancelRegulation), for: .touchUpInside)
        pauseView.addSubview(cancelBtn)
        //////////////////////////////////////////
        regulation.text = "規則說明\n\n遊戲開始時會產生1-4隨機排列的組合\n玩家必須猜測並輸入\n簡單模式為不重複數字(24種組合)\n困難模式則會重複(256種組合)"
        regulation.font = regulation.font.withSize(30.0)
        //不限制行數
        regulation.numberOfLines = 0
        //regulation.lineBreakMode = .byWordWrapping
        //////////////////////////////////////////
        regulation.textAlignment = .center
        regulation.textColor = UIColor.white
        //regulation.backgroundColor = UIColor.red
        let regulationFrame = CGRect(x: 60, y: 70, width: self.view.frame.width - 120, height: self.view.frame.height - 140)
        regulation.frame = regulationFrame
        pauseView.addSubview(regulation)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("userName:\(userNameFromLogIn)")
        
        
    }
    
   
    @objc func cancelRegulation()
    {
        cancelBtn.removeFromSuperview()
        regulation.removeFromSuperview()
        pauseView.removeFromSuperview()
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
