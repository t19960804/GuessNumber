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
class MainPage: UIViewController {
    var seconds  = 3
    var timer = Timer()
    /////////////////////////////
    var numberArray : [Int] = [1,2,3,4]
    var randomArray : [Int] = []
    var inputArray : [Int] = []
    var right : Int = 0
    var wrong : Int = 0
    var counter  = Float()
    var btn = UIButton()
    var pauseView = UIView()
    var countDownLabel = UILabel()
    @IBOutlet weak var rightCount: UILabel!
    @IBOutlet weak var wrongCount: UILabel!
    @IBOutlet weak var inputNo1: UITextField!
    @IBOutlet weak var inputNo2: UITextField!
    @IBOutlet weak var inputNo3: UITextField!
    @IBOutlet weak var inputNo4: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    var textFieldsArray = [UITextField]()
    /////
    @IBAction func startBtn(_ sender: UIButton) {
       
        
            //開始計時
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        
            
       
            //計時停止
            //timer.invalidate()
        
        
    }
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
        
        let frame = CGRect(x:0,y:20,width:self.view.frame.width,height:self.view.frame.height)
        pauseView = UIView(frame: frame)
        pauseView.backgroundColor = UIColor.black
        pauseView.alpha = 0.5
        ////////////////////////////////
        self.view.addSubview(pauseView)
        ////////////////////////////////
        let btnImage = UIImage(named: "play.png")
        
        let btnFrame = CGRect(x:(self.view.center.x) /  2 ,
                              y:(self.view.center.y) / 2,
                              width:(btnImage?.size.width)!,
                              height:(btnImage?.size.height)!)
        
        
        btn = UIButton(type: .custom)
        btn.setImage(btnImage, for: .normal)
        btn.frame = btnFrame
        btn.addTarget(self, action: #selector(self.playButton), for: .touchUpInside)
        ////////////////////////////////
        pauseView.addSubview(btn)
        ////////////////////////////////
        
    }
    @IBOutlet weak var timerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        noRepeatNumbers()
        textFieldsArray.append(inputNo1)
        textFieldsArray.append(inputNo2)
        textFieldsArray.append(inputNo3)
        textFieldsArray.append(inputNo4)
        
        
    }
    //計時器累加並顯示
    @objc func UpdateTimer() {
        counter = counter + 0.1
        timerLabel.text = String(format: "%.1f", counter)
    }
    //點擊背景可收回鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
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
            //加入使用者輸入數字
            inputArray.append(Int(textFieldsArray[i].text!)!)
            
            
        }
    }
    //檢查陣列裡每個index
    func loopCheck()
    {
        for i in 0...inputArray.count - 1
        {
            checkEachNumber(Index: i)
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
        
        
    }
    func simpleHint() {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "挑戰成功!!!",
            message: "時間:\((timerLabel.text)!)秒",
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
    //點擊"繼續"按鈕後事件
    @objc func playButton()
    {
        btn.removeFromSuperview()
        pauseView.removeFromSuperview()
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
        runTimer()

    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        countDownLabel.text = "\(seconds)" //This will update the label.
        if (seconds == 0)
        {
            timer.invalidate()
            countDownLabel.removeFromSuperview()

        }
    }
}
