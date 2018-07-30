//
//  RegisterController.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/7/29.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func insertUserToDB(_ sender: UIButton) {
        SVProgressHUD.show()
        if userNameTextField.text == "" || passwordTextField.text == ""
        {
            showAlert()
        }
        else
        {
            Auth.auth().createUser(withEmail: userNameTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error == nil
                {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "RegisterToViewController", sender: self)
                    print("Register Success")
                }
                else
                {
                    print(error!)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
