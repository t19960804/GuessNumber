//
//  LogInPage.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/7/29.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
class LogInPage: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    
    @IBAction func logInBtn(_ sender: UIButton) {
        SVProgressHUD.show()
        //有一個欄位是空的就跳警告
        if userNameTextField.text == "" || passwordTextField.text == ""
        {
            showAlert()
        }
        else
        {
            Auth.auth().signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error == nil
                {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "LogInToViewController", sender: self)
                    print("LogIn Success")
                }
                else
                {
                    print("error:",error)
                }
            }
        }
        
        
        
    }
    @IBAction func registerBtn(_ sender: UIButton) {
       print("2")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = "h@h.com"
        passwordTextField.text = "hhhhhh"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func showAlert()
    {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "輸入錯誤!!!",
            message: "尚有欄位未填",
            preferredStyle: .alert)
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "知道了",
            style: .default,
            handler: nil)
        alertController.addAction(okAction)
        
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
        
    }

}
