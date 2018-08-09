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
class ViewController: UIViewController {
    @IBOutlet weak var easyModeBtn: UIButton!
    @IBOutlet weak var hardModeBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var regulationBtn: UIButton!
    var easyModelController = EasyModeController()
    var pauseView = UIView()
    var cancelBtn = UIButton()
    var regulation = UILabel()
    var userNameFromLogIn = String()
    
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
        //print("width:\(self.view.frame.width)  height:\(self.view.frame.height)")
        print("userName:\(userNameFromLogIn)")
    }
    override func viewDidDisappear(_ animated: Bool) {
        //mainPageController.runCountDownTimer()
        print("disappear")
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
                    self.dismiss(animated: true, completion: nil)
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
}
