
import UIKit
import Firebase
import SVProgressHUD
import FBSDKLoginKit
import RealmSwift
import GoogleSignIn
import GoogleMobileAds

class LogInPage: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    let realm = try! Realm()
    var emailFromSocialNetWork = String()
    

    var allUserFromRealm: Results<User>?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var btnOutletOfFaceBook: UIButton!
    @IBOutlet weak var btnOutletOfGoogle: UIButton!
    @IBOutlet weak var adsBanner: GADBannerView!
    
    
    @IBAction func logInWithFaceBookBtn(_ sender: UIButton) {
        //可以讀取用戶的基本資料和取得用戶email的權限
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) in

        if error != nil{
            print("LogIn Fail")
            return
        }
        self.logInWithFaceBook()
        
        }
        
    }
    @IBAction func logInWithGoogleBtn(_ sender: UIButton) {GIDSignIn.sharedInstance().signIn()}
    
    
    @IBAction func logInBtn(_ sender: UIButton) {
        SVProgressHUD.show()
        //有一個欄位是空的就跳警告
        if userNameTextField.text == "" || passwordTextField.text == ""{
            SVProgressHUD.dismiss()
            AlertController.showBasicAlert(viewController: self, title: "尚有欄位未填", message: "請繼續輸入")
        }
        else if (passwordTextField.text?.count)! < 6{
                SVProgressHUD.dismiss()
            AlertController.showBasicAlert(viewController: self, title: "密碼不足六位數", message: "請繼續輸入")
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
                        AlertController.showBasicAlert(viewController: self, title: "帳號密碼有誤", message: "請重新輸入")
                    }
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = "h@h.com"
        passwordTextField.text = "hhhhhh"
        btnOutletOfFaceBook.layer.cornerRadius = round(5.0)
        btnOutletOfGoogle.layer.cornerRadius = round(5.0)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        //showAds()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logInToViewController"
        {
            let destination = segue.destination as! ViewController
            
            if userNameTextField.text != ""
            {
                destination.userNameFromLogIn = userNameTextField.text!
                
            }
            else
            {
                destination.userNameFromLogIn = emailFromSocialNetWork
            }

        }
        
        
        
        
        
        
    }
    //MARK: - FaceBook處理
    func logInWithFaceBook()
    {
        //acess token是Facebook用來辨識你的身份的字串，辨識成功後就可以取用Facebook的資料
        
        guard let accessToken = FBSDKAccessToken.current().tokenString else{fatalError()}
        //將token轉換為FireBase的憑證
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
                self.emailFromSocialNetWork = results.object(forKey: "email") as! String
                //確認Realm裡是否有該帳號
                if self.checkSocialUserExist(email: self.emailFromSocialNetWork) == true
                {
                    self.performSegue(withIdentifier: "logInToViewController", sender: self)
                }
                else
                {

                    self.createSocialUser(email: self.emailFromSocialNetWork)
                    //不加在它獲得email之後才跳轉,會最後才觸發
                    self.performSegue(withIdentifier: "logInToViewController", sender: self)
                }
                
            }
        }
    }
    //MARK: - Google處理
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil
        {
            print("Log In Fail:",error)
            return
        }
        else
        {
            self.emailFromSocialNetWork = user.profile.email!
            print("Log In Success:",user.profile.email!)
        }
        //建立user在FireBase
        guard let idToken = user.authentication.idToken else {fatalError("idToken is nil")}
        guard let accessTokens  = user.authentication.accessToken else {fatalError("accessTokens is nil")}
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessTokens)
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if error != nil
            {
                print("Sign In Fail:\(error)")
            }
            //確認Realm裡是否有該帳號
            else if self.checkSocialUserExist(email: self.emailFromSocialNetWork) == true
            {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "logInToViewController", sender: self)
            }
            else
            {
                SVProgressHUD.dismiss()
                self.createSocialUser(email: self.emailFromSocialNetWork)
                //不加在它獲得email之後才跳轉,會最後才觸發
                self.performSegue(withIdentifier: "logInToViewController", sender: self)
            }
        }
    }
    //MARK: Realm相關處理
    func createSocialUser(email: String){
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
    func checkSocialUserExist(email: String) -> Bool
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
//    func showAds()
//    {
//        //官網:ca-app-pub-3940256099942544/2934735716
//        //自己:ca-app-pub-5941469490008558/7651326092
//        let request = GADRequest()
//        adsBanner.adUnitID = "ca-app-pub-5941469490008558/7651326092"
//        adsBanner.rootViewController = self
//        //request.testDevices = [ kGADSimulatorID ]
//        adsBanner.load(request)
//
//    }
}

