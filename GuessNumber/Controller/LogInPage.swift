
import UIKit
import Firebase
import SVProgressHUD

class LogInPage: UIViewController {
    var user = User()
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    @IBAction func logInBtn(_ sender: UIButton) {
        SVProgressHUD.show()
        //有一個欄位是空的就跳警告
        if userNameTextField.text == "" || passwordTextField.text == ""
        {
            SVProgressHUD.dismiss()
            showAlert(title: "尚有欄位未填", message: "請繼續輸入")
        }
        else if (passwordTextField.text?.count)! < 6
        {
            
            
                SVProgressHUD.dismiss()
                showAlert(title: "密碼不足六位數", message: "請繼續輸入")
                
            
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
                        SVProgressHUD.dismiss()
                        print("error:\(error!)\n")
                        self.showAlert(title: "帳號密碼有誤", message: "請重新輸入")
                    }
                }
        }
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = "a@a.com"
        passwordTextField.text = "aaaaaa"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func showAlert(title: String,message: String)
    {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "\(title)",
            message: "\(message)",
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LogInToViewController"
        {
        let destination = segue.destination as! ViewController
        
        destination.userNameFromLogIn = userNameTextField.text!
        
        }
    }
}
