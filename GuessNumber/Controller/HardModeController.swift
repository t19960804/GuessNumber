//
//  HardModeController.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/6/16.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import UIKit
import GameKit
class HardModeController: UIViewController {

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
    let device = UIDevice.current
    var keyBoardNeedLayout: Bool = true
    @IBOutlet weak var rightCount: UILabel!
    @IBOutlet weak var wrongCount: UILabel!
    @IBOutlet weak var inputNo1: UITextField!
    @IBOutlet weak var inputNo2: UITextField!
    @IBOutlet weak var inputNo3: UITextField!
    @IBOutlet weak var inputNo4: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    
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
            //print("width:\(self.view.frame.width) height:\(self.view.frame.height)")
            print("self.x:\(self.view.center.x) self.y:\(self.view.center.y)")
            print("x:\(btn.center.x) y:\(btn.center.y)")
        }
        else{
            createPauseViewAndButton(X: 0, Y: 20, Width: self.view.frame.width, Height: self.view.frame.height)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RepeatNumbers()
        textFieldsArray.append(inputNo1)
        textFieldsArray.append(inputNo2)
        textFieldsArray.append(inputNo3)
        textFieldsArray.append(inputNo4)

        //当键盘弹起的时候会向系统发出一个通知，
        //这个时候需要注册一个监听器响应该通知self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        //当键盘收起的时候会向系统发出一个通知，
        //这个时候需要注册另外一个监听器响应该通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
       
        //感知设备方向 - 开启监听设备方向
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        //添加通知，监听设备方向改变
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedRotation),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //关闭设备监听
        //UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
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
    //點擊背景可收回鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //產生不重複亂數
    func RepeatNumbers()
    {
        
        for i in  0...numberArray.count - 1
        {
            let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: numberArray.count)
            randomArray.append(numberArray[randomNumber])
            
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
        RepeatNumbers()
        for i in 0...textFieldsArray.count - 1
        {
            textFieldsArray[i].text = ""
        }
        timerLabel.text = "0.0"
        counter = 0
        timer.invalidate()
        countDownLabelSetting()
        runCountDownTimer()
        
    }
    func simpleHint() {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "挑戰成功!!!",
            message: "時間:\((timerLabel.text)!)",
            preferredStyle: .alert)
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "離開",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "重新開始",
            style: .cancel,
            handler: {
                (action: UIAlertAction!) -> Void in
                self.resumeGame()})
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
        runCountDownTimer()
        
        
    }
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
            runGameTimer()
            seconds = 3
            
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
        runCountDownTimer()
        
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
        print("hide")
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
    
   
}
