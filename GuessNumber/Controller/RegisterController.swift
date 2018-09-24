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
import RealmSwift

class RegisterController: UIViewController {
    let realm = try! Realm()
    let userNameWasUsed = "The email address is already in use by another account."
    var user = User()
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func cancelBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func insertUserToDB(_ sender: UIButton) {
        SVProgressHUD.show()
        if userNameTextField.text == "" || passwordTextField.text == ""
        {
            SVProgressHUD.dismiss()
            AlertController.showBasicAlert(viewController: self, title: "尚有欄位未填", message: "請繼續輸入")

        }
        else if (passwordTextField.text?.count)! < 6
        {
            
            
            SVProgressHUD.dismiss()
            AlertController.showBasicAlert(viewController: self, title: "密碼不足六位數", message: "請繼續輸入")
                
        }
            
        else
        {
                //FireBase驗證後建立
                Auth.auth().createUser(withEmail: userNameTextField.text!, password: passwordTextField.text!) { (result, error) in
                    if error == nil
                    {
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "RegisterToViewController", sender: self)
                        self.addUser(userName: self.userNameTextField.text!)
                        print("Register Success")
                    }
                    else if error!.localizedDescription == self.userNameWasUsed
                    {
                        print("Register error:\(error!)\n")
                        SVProgressHUD.dismiss()
                        //self.showAlert(title: "帳號已被使用", message: "請重新輸入")
                        AlertController.showBasicAlert(viewController: self, title: "帳號已被使用", message: "請重新輸入")
                        
                    }
                    else{
                        print("Format Error:\(error!)")
                        SVProgressHUD.dismiss()
                        //self.showAlert(title: "帳號格式錯誤", message: "請重新輸入")
                        AlertController.showBasicAlert(viewController: self, title: "帳號格式錯誤", message: "請重新輸入")
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
   
    
    func addUser(userName: String)
   {
    
        let user = User()
        user.userName = userName
        do{
            try realm.write {
                realm.add(user)
            }
        }catch{
            print("Add User Fail")
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterToViewController"
        {
            let destination = segue.destination as! ViewController
            
            destination.userNameFromLogIn = userNameTextField.text!
            
        }
    }

}
