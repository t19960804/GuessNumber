//
//  MainPage.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/6/9.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import UIKit
import GameKit
import CountdownLabel
import Firebase
import RealmSwift

class EasyModeController: UIViewController {
    var seconds  = 3
    var timer = Timer()
    var countDowntimer = Timer()
    /////////////////////////////
    var numberArray : [Int] = [1,2,3,4]
    var randomArray : [Int] = []
    var inputArray : [Int] = []
    var right : Int = 0
    var wrong : Int = 0
    var counter  = Float()
    var minuteCount = 0
    var btn = UIButton()
    var pauseView = UIView()
    var countDownLabel = UILabel()
    var textFieldsArray = [UITextField]()
    var keyBoardNeedLayout: Bool = true
    var userName = String()
    let device = UIDevice.current
    let email = (Auth.auth().currentUser?.email)!
    let realm = try! Realm()
    var currentUser = User()
    var allScore: Results<Score>?
    /////////////////////////////
    @IBOutlet weak var rightCount: UILabel!
    @IBOutlet weak var wrongCount: UILabel!
    @IBOutlet weak var inputNo1: UITextField!
    @IBOutlet weak var inputNo2: UITextField!
    @IBOutlet weak var inputNo3: UITextField!
    @IBOutlet weak var inputNo4: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pauseBtnOutlet: UIButton!
    @IBOutlet weak var checkBtnOutlet: UIButton!
    @IBAction func checkBtn(_ sender: UIButton) {
        
        //如果inputArray是空的則不用清空,直接append
        //每次check前先將 right &  wrong計數器歸0
        if inputArray.isEmpty
        {
            right = 0
            wrong = 0
            inputArrayAppend()
            loopCheck()
            

        }
        else
            
        {
            inputArray.removeAll()
            right = 0
            wrong = 0
            inputArrayAppend()
            loopCheck()
            
        }
       
    }
    
    @IBAction func pauseBtn(_ sender: UIButton) {
        //遊戲計時停止
        timer.invalidate()
        if device.orientation.isLandscape{
            
            createPauseViewAndButton(X: 0, Y: 0, Width: self.view.frame.width, Height: self.view.frame.height)
            
        }
        else{
            createPauseViewAndButton(X: 0, Y: 20, Width: self.view.frame.width, Height: self.view.frame.height)

        }
    }
    @IBAction func scoreBoardBtn(_ sender: UIButton) {
        loadScore()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadScore()
        noRepeatNumbers()
        
        textFieldsArray.append(inputNo1)
        textFieldsArray.append(inputNo2)
        textFieldsArray.append(inputNo3)
        textFieldsArray.append(inputNo4)
        
        //感知设备方向 - 开启监听设备方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        //添加通知，监听设备方向改变
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedRotation),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //點擊背景可收回鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //MARK: 遊戲規則處理
    //產生不重複亂數
    func noRepeatNumbers()
    {
        
        for i in  0...numberArray.count - 1
            {
                let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: numberArray.count)
                randomArray.append(numberArray[randomNumber])
                numberArray.remove(at: randomNumber)
                print("random:",randomArray[i])
                
            }
        }
    func checkEachNumber(Index index : Int )
    {
        //兩個陣列裡對應到的index相比較
        if inputArray[index] == randomArray[index]
        {
            right += 1
            rightCount.text = String(right)
            wrongCount.text = String(wrong)
           if right == 4
           {
                    simpleHint()
                    timer.invalidate()
            }
            
        }
        else
        {
            wrong += 1
            rightCount.text = String(right)
            wrongCount.text = String(wrong)
            
        }
    }
    //將textField的數字加入陣列
    func inputArrayAppend()
    {
        for i in 0...textFieldsArray.count - 1
        {
            if (textFieldsArray[i].text != "")
            {
            //加入使用者輸入數字
            inputArray.append(Int(textFieldsArray[i].text!)!)
            }
            else{
                
                break
            }
            
        }
    }
    //檢查陣列裡每個index
    func loopCheck()
    {
        if (inputArray.count == 4)
        {
            for i in 0...inputArray.count - 1
            {
                
                checkEachNumber(Index: i)
            }
        }
        else
        {
            textNilHint()
            
        }
    }
    //重新產生亂數,並且清空textField / randomArray / inputArray
    func resumeGame()
    {
        randomArray.removeAll()
        inputArray.removeAll()
        rightCount.text = "0"
        wrongCount.text = "0"
        numberArray = [1,2,3,4]
        noRepeatNumbers()
        for i in 0...textFieldsArray.count - 1
        {
            textFieldsArray[i].text = ""
        }
        timerLabel.text = "0.0"
        counter = 0
        timer.invalidate()
        countDownLabelSetting()
        componentIsEnabled(parameter: false)
        runCountDownTimer()
        
    }
    // MARK: 系統提示
    func simpleHint() {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "挑戰成功!!!",
            message: "時間:\((timerLabel.text)!)",
            preferredStyle: .alert)
        
        // 建立[離開]按鈕
        let okAction = UIAlertAction(
            title: "離開",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                self.dismiss(animated: true, completion: nil)
                self.addDataToFireBase(Email: self.email, Score: (self.timerLabel.text)!)
                self.addScore(gameScore: (self.timerLabel.text)!)
        })
        alertController.addAction(okAction)
        // 建立[重新開始]按鈕
        let cancelAction = UIAlertAction(
            title: "重新開始",
            style: .cancel,
            handler: {
                (action: UIAlertAction!) -> Void in
                self.resumeGame()
                self.addDataToFireBase(Email: self.email, Score: (self.timerLabel.text)!)
                self.addScore(gameScore: (self.timerLabel.text)!)
        })
        alertController.addAction(cancelAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    func  textNilHint()
    {
        self.timer.invalidate()
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "請輸入數字!!!",
            message: "尚有數字未填",
            preferredStyle: .alert)
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "知道了",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                
                self.runCountDownTimer()
        })
        alertController.addAction(okAction)
        
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    //點擊"繼續"按鈕後事件
    @objc func playButton()
    {
        btn.removeFromSuperview()
        pauseView.removeFromSuperview()
        countDownLabelSetting()
        //元件無法使用
        componentIsEnabled(parameter: false)
        runCountDownTimer()
        

    }
    // MARK: 計時處理
    func runGameTimer()
    {
        //開始計時
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    func runCountDownTimer() {
        countDowntimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.countDown)), userInfo: nil, repeats: true)
       
        
    }
    @objc func countDown() {
        
        seconds -= 1     //This will decrement(count down)the seconds.
        countDownLabel.text = "\(seconds)" //This will update the label.
        if (seconds == 0)
        {
            countDowntimer.invalidate()
            countDownLabel.removeFromSuperview()
            componentIsEnabled(parameter: true)
            runGameTimer()
            seconds = 3
            
        }
    }
    //計時器累加並顯示
    @objc func UpdateTimer() {
        
        counter = counter + 0.1
        timerLabel.text = "\(minuteCount)分 \(String(format: "%.1f", counter))秒"
        if counter >= 59.9
        {
            minuteCount = minuteCount + 1
            counter = 0.0
            timerLabel.text = "\(minuteCount)分 \(String(format: "%.1f", counter))秒"
        }
    }
    func countDownLabelSetting()
    {
        let countDownFrame = CGRect(x:0,
                                    y:0,
                                    width:self.view.frame.width,
                                    height:self.view.frame.height)
        countDownLabel.frame = countDownFrame
        countDownLabel.textAlignment = .center
        
        countDownLabel.textColor = UIColor(red: 1.0, green: 188/255, blue: 0.0, alpha: 1.0)
        countDownLabel.font = countDownLabel.font.withSize(250.0)
        countDownLabel.text = "3"
        self.view.addSubview(countDownLabel)
    }
    
    func createPauseViewAndButton(X x :CGFloat,Y y :CGFloat,Width width :CGFloat,Height height :CGFloat)
    {
        let frame = CGRect(x:x,y:y,width:width,height:height)
        pauseView = UIView(frame: frame)
        pauseView.backgroundColor = UIColor.black
        pauseView.alpha = 0.5
        ////////////////////////////////
        self.view.addSubview(pauseView)
        ////////////////////////////////
        let btnImage = UIImage(named: "playbutton.png")
        
//        let btnFrame = CGRect(x:0  ,
//                              y:0  ,
//                              width:(btnImage?.size.width)!,
//                              height:(btnImage?.size.height)!)
        
        let btnFrame = CGRect(x:0  ,
                              y:0  ,
                              width:self.view.frame.width,
                              height:self.view.frame.height)
        
        btn = UIButton(type: .custom)
        btn.setImage(btnImage, for: .normal)
        btn.frame = btnFrame
        btn.addTarget(self, action: #selector(self.playButton), for: .touchUpInside)
        ////////////////////////////////
        pauseView.addSubview(btn)
        ////////////////////////////////
    }
    //通知监听触发的方法
    @objc func receivedRotation(){
        //let device = UIDevice.current
        switch device.orientation{
        case .portrait:
            print("面向设备保持垂直，Home键位于下部")
        case .portraitUpsideDown:
            print("面向设备保持垂直，Home键位于上部")
        case .landscapeLeft:
            print("面向设备保持垂直，Home键位于右部")
        case .landscapeRight:
            print("面向设备保持水平，Home键位于左侧")
       
        default:
            print("方向未知")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        countDownLabelSetting()
        componentIsEnabled(parameter: false)
        runCountDownTimer()
        
        ////////////////////////
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        print("show")
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            
            let deltaY = intersection.height
            
            if keyBoardNeedLayout {
                UIView.animate(withDuration: duration, delay: 0.0,
                               options: UIViewAnimationOptions(rawValue: curve),
                               animations: {
                                self.view.frame = CGRect(x:0,y:-deltaY / 2,width:self.view.bounds.width,height:self.view.bounds.height)
                                self.keyBoardNeedLayout = false
                                self.view.layoutIfNeeded()
                }, completion: nil)
            }
            
            
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            
            let deltaY = intersection.height
            
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIViewAnimationOptions(rawValue: curve),
                           animations: {
                            self.view.frame = CGRect(x:0,y:deltaY / 2,width:self.view.bounds.width,height:self.view.bounds.height)
                            self.keyBoardNeedLayout = true
                            self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    func addDataToFireBase(Email: String,Score: String)
    {
        //將UserName做切割存進FireBase
        let seperateUserName = Email.components(separatedBy: "@")
        let reference = Database.database().reference().child("\(seperateUserName[0])")
        let dictionary = ["Score" : Score]
        reference.childByAutoId().setValue(dictionary){
        (error,reference) in
            if error == nil
            {
                print("Insert Score Success")
            }
            else
            {
                print(error!)
            }
        }
        
    }
    
    // MARK: 元件失效
    func componentIsEnabled(parameter: Bool)
    {
        inputNo1.isEnabled = parameter
        inputNo2.isEnabled = parameter
        inputNo3.isEnabled = parameter
        inputNo4.isEnabled = parameter
        
        pauseBtnOutlet.isEnabled = parameter
        checkBtnOutlet.isEnabled = parameter

    }
    
    //MArk: Realm相關操作
    func addScore(gameScore: String)
    {
        let newScore = Score()
        newScore.score  = gameScore
        newScore.mode = "簡單模式"
        do{
            try realm.write {
                realm.add(newScore)
                currentUser.scores.append(newScore)
                print("Add Data Success")
            }
        }catch{
            print("Add Data Fail:\(error)")
        }
       
    }
    func loadScore(){
        allScore = currentUser.scores.filter("mode CONTAINS[cd] %@", "簡單模式").sorted(byKeyPath: "score", ascending: true)
        for eachScore in allScore!
        {
            print("\(eachScore.mode):\(eachScore.score)")
        }
    }
    
}
