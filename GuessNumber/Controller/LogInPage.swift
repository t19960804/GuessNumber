
import UIKit
import Firebase
import SVProgressHUD
import FBSDKLoginKit
import RealmSwift

class LogInPage: UIViewController {
    let realm = try! Realm()
    var emailFromFaceBook = String()
    var allUserFromRealm: Results<User>?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func logInWithFaceBookBtn(_ sender: UIButton) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) in

        if error != nil{
            print("LogIn Fail")
            return
        }
        self.logInWithFaceBook()
        
        }
        
    }
    @IBAction func logInBtn(_ sender: UIButton) {
        SVProgressHUD.show()
        //有一個欄位是空的就跳警告
        if userNameTextField.text == "" || passwordTextField.text == ""{
            SVProgressHUD.dismiss()
            showAlert(title: "尚有欄位未填", message: "請繼續輸入")
        }
        else if (passwordTextField.text?.count)! < 6{
                SVProgressHUD.dismiss()
                showAlert(title: "密碼不足六位數", message: "請繼續輸入")
        }
        else{
                Auth.auth().signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!) { (result, error) in
                    if error == nil{
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "logInToViewController", sender: self)
                    }
                    else{
                        SVProgressHUD.dismiss()
                        print("error:\(error!)\n")
                        self.showAlert(title: "帳號密碼有誤", message: "請重新輸入")
                    }
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userNameTextField.text = "a@a.com"
//        passwordTextField.text = "aaaaaa"
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
        
        let destination = segue.destination as! ViewController
        
        if userNameTextField.text != ""
        {
            destination.userNameFromLogIn = userNameTextField.text!

        }
        else
        {
            destination.userNameFromLogIn = emailFromFaceBook
        }

        
        
        
        
        
    }
    //MARK: FaceBook處理

    
    func logInWithFaceBook()
    {
        
        //acess token是Facebook用來辨識你的身份的字串，辨識成功後就可以取用Facebook的資料
        
        guard let accessToken = FBSDKAccessToken.current().tokenString else{fatalError()}
        //credential像是登入金鑰，取得fbCredentials後，才能前往firebase
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
            if error != nil{
                print("SignIn Fail:\(error)")
            }
            
        }
        
        //使用 Graph API可以擷取個人檔案資訊以提供社交元素
        //參數以"fields"為Key值
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email"]).start { (connection, result, error) in
            if error != nil{
                print("Fail to request")
                return
            }
            else{
                guard let results = result as? NSDictionary else{fatalError("result as NSDictionary fail")}
                //從回傳的結果取出Email
                self.emailFromFaceBook = results.object(forKey: "email") as! String
                //確認Realm裡是否有該帳號
                if self.checkFaceBookUserExist(email: self.emailFromFaceBook) == true
                {
                    self.performSegue(withIdentifier: "logInToViewController", sender: self)
                }
                else
                {
                    self.createFaceBookUser(email: self.emailFromFaceBook)
                    //不加在它獲得email之後才跳轉,會最後才觸發
                    self.performSegue(withIdentifier: "logInToViewController", sender: self)
                }
                
            }
        }
    }
    func createFaceBookUser(email: String){
        let user = User()
        user.userName = email
        do{
            try realm.write {
                realm.add(user)
            }
        }catch{
            print("Add User Fail")
        }
    }
    func checkFaceBookUserExist(email: String) -> Bool
    {
        //將所有儲存在Realm的資料撈出來比對
        allUserFromRealm = realm.objects(User.self)
        for user in allUserFromRealm!
        {
            if email == user.userName
            {
                return true
                
                
            }
            
            
        }
        return false
    }
}
