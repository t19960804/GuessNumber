//
//  MainPage.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/6/9.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import UIKit
import GameKit
import RealmSwift

class EasyModeController: UIViewController {
    var seconds  = 3
    var timer = Timer()
    var countDowntimer = Timer()
    /////////////////////////////
    var numberArray : [Int] = [1,2,3,4]
    var randomArray : [Int] = []
    var inputArray : [Int] = []
    //純加入
    var textFieldsArray = [UITextField]()
    //加入設定後
    var settedTextFieldsArray = [UITextField]()
    var right : Int = 0
    var wrong : Int = 0
    var counter  = Float()
    var minuteCount = 0
    /////////////////////////////
    var pauseView_pauseBtn = UIButton()
    var pauseView_cancelBtn = UIButton()
    var pauseView_scoreLabel = UILabel()
    var pauseView_timeLabel = UILabel()
    var pauseView = UIView()
    let scoreTableView = UITableView()

    /////////////////////////////
    var countDownLabel = UILabel()
    var keyBoardNeedLayout: Bool = true
    
    let device = UIDevice.current
    //let email = (Auth.auth().currentUser?.email)!
    let emailFromFaceBook = String()
    let realm = try! Realm()
    var currentUser = User()
    var allScore: Results<Score>?
    var withinFiveScore = [String]()
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
    @IBOutlet weak var scoreBoardBtnOutlet: UIButton!
    
    @IBAction func checkBtn(_ sender: UIButton) {
        
        //如果inputArray是空的則不用清空,直接append
        //每次check前先將 right &  wrong計數器歸0
        if inputArray.isEmpty
        {
            checkAnserHandler()
        }
        else
            
        {
            inputArray.removeAll()
            checkAnserHandler()
        }
       
    }
    
    @IBAction func pauseBtn(_ sender: UIButton) {
        //遊戲計時停止
        timer.invalidate()
        createPauseViewAndButton()

        
    }
    @IBAction func scoreBoardBtn(_ sender: UIButton) {
        timer.invalidate()
        createPauseViewAndScoreLabel()

        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noRepeatNumbers()
        
        textFieldsArray.append(inputNo1)
        textFieldsArray.append(inputNo2)
        textFieldsArray.append(inputNo3)
        textFieldsArray.append(inputNo4)
        textFieldSetting()
        loadScore()
        scoreTableView.delegate  = self
        scoreTableView.dataSource = self
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //點擊背景可收回鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK: 遊戲規則處理
    func checkAnserHandler()
    {
        right = 0
        wrong = 0
        inputArrayAppend()
        loopCheck()
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
        for i in 0...settedTextFieldsArray.count - 1
        {
            if (settedTextFieldsArray[i].text != "")
            {
            //加入使用者輸入數字
            inputArray.append(Int(settedTextFieldsArray[i].text!)!)
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
        for i in 0...settedTextFieldsArray.count - 1
        {
            settedTextFieldsArray[i].text = ""
        }
        timerLabel.text = "0.0"
        counter = 00.0
        timer.invalidate()
        countDownLabelSetAndRun()
        componentIsEnabled(parameter: false)
        
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
                self.addScore(gameScore: (self.timerLabel.text)!)
                self.dismiss(animated: true, completion: nil)
                
                
                
        })
        alertController.addAction(okAction)
        // 建立[重新開始]按鈕
        let cancelAction = UIAlertAction(
            title: "重新開始",
            style: .cancel,
            handler: {
                (action: UIAlertAction!) -> Void in
                self.addScore(gameScore: (self.timerLabel.text)!)
                self.resumeGame()

                
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
        
            self.pauseView_pauseBtn.removeFromSuperview()
            self.pauseView.removeFromSuperview()
        
        
        countDownLabelSetAndRun()
        //元件無法使用
        componentIsEnabled(parameter: false)
        

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
        
        counter = counter + 00.1
        if counter <= 9.9
        {
            timerLabel.text = "\(minuteCount)分 0\(String(format: "%.1f", counter))秒"
        }
        else if counter >= 59.9
        {
            minuteCount = minuteCount + 1
            counter = 00.0
            timerLabel.text = "\(minuteCount)分 \(String(format: "%.1f", counter))秒"
        }
        else
        {
            timerLabel.text = "\(minuteCount)分 \(String(format: "%.1f", counter))秒"
        }
        
    }
    func countDownLabelSetAndRun()
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

        runCountDownTimer()
    }
    //MARK: 自訂元件
    //先把View加入,才能設定Constraints
    func createPauseView(){
        
        pauseView.backgroundColor = UIColor.black
        pauseView.alpha = 0.7
        self.view.addSubview(pauseView)
        ////////////////////////////////
        pauseView.translatesAutoresizingMaskIntoConstraints = false
        let leading = NSLayoutConstraint(item: pauseView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: pauseView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: pauseView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: pauseView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leading,trailing,top,bottom])
        
        
        
    }
    func createPauseViewAndButton()
    {
        createPauseView()
        let btnImage = UIImage(named: "playbutton.png")
        pauseView_pauseBtn = UIButton(type: .custom)
        pauseView_pauseBtn.setImage(btnImage, for: .normal)
        pauseView_pauseBtn.addTarget(self, action: #selector(self.playButton), for: .touchUpInside)
        ////////////////////////////////
        pauseView.addSubview(pauseView_pauseBtn)
        pauseView_pauseBtn.translatesAutoresizingMaskIntoConstraints = false
        let verticalInCenter = NSLayoutConstraint(item: pauseView_pauseBtn, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: pauseView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let horizontalInCenter = NSLayoutConstraint(item: pauseView_pauseBtn, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: pauseView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        NSLayoutConstraint(item: pauseView_pauseBtn, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300).isActive = true
        NSLayoutConstraint(item: pauseView_pauseBtn, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300).isActive = true
        NSLayoutConstraint.activate([verticalInCenter,horizontalInCenter])
    }
    func createPauseViewAndScoreLabel()
    {
        createPauseView()
        /////////////////////////////////
        let cancelBtnImage = UIImage(named: "cancel.png")
        pauseView_cancelBtn = UIButton(type: .custom)
        pauseView_cancelBtn.setImage(cancelBtnImage, for: .normal)
        pauseView_cancelBtn.addTarget(self, action: #selector(self.cancelScoreBoard), for: .touchUpInside)
        pauseView.addSubview(pauseView_cancelBtn)
        pauseView_cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        let trailing = NSLayoutConstraint(item: pauseView_cancelBtn, attribute: .trailing, relatedBy: .equal, toItem: pauseView, attribute: .trailing, multiplier: 1, constant: -20)
        let top = NSLayoutConstraint(item: pauseView_cancelBtn, attribute: .top, relatedBy: .equal, toItem: pauseView, attribute: .top, multiplier: 1, constant: 20)
        NSLayoutConstraint(item: pauseView_cancelBtn, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: pauseView_cancelBtn, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint.activate([trailing,top])

        setScoreTableView()

    }
    func setTheBestTime(){
        pauseView_timeLabel.text = "最佳時間"
        pauseView_timeLabel.textColor = UIColor.white
        pauseView_timeLabel.textAlignment = .center
        pauseView_timeLabel.font = pauseView_timeLabel.font.withSize(40.0)
        pauseView.addSubview(pauseView_timeLabel)
        
        pauseView_timeLabel.translatesAutoresizingMaskIntoConstraints = false
        let horizontalInCenter = NSLayoutConstraint(item: pauseView_timeLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: pauseView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: pauseView_timeLabel, attribute: .top, relatedBy: .equal, toItem: pauseView, attribute: .top, multiplier: 1, constant: 30)
        let bottom = NSLayoutConstraint(item: pauseView_timeLabel, attribute: .bottom, relatedBy: .equal, toItem: scoreTableView, attribute: .top, multiplier: 1, constant: 30)
        NSLayoutConstraint(item: pauseView_timeLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: pauseView_timeLabel, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1 , constant: 250).isActive = true
        NSLayoutConstraint.activate([horizontalInCenter,top,bottom])
    }
    func setScoreTableView(){

        scoreTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        scoreTableView.backgroundColor = UIColor.black
        scoreTableView.alpha = 0.5
        scoreTableView.separatorStyle = .singleLine
        pauseView.addSubview(scoreTableView)
        //////////////////////////////////
        scoreTableView.translatesAutoresizingMaskIntoConstraints = false

        let verticalInCenter = NSLayoutConstraint(item: scoreTableView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: pauseView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let horizontalInCenter = NSLayoutConstraint(item: scoreTableView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: pauseView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint(item: scoreTableView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 400).isActive = true
        NSLayoutConstraint(item: scoreTableView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 400).isActive = true
        NSLayoutConstraint.activate([verticalInCenter,horizontalInCenter])
        setTheBestTime()
        
    }
    @objc func cancelScoreBoard()
    {
        
        self.pauseView.removeFromSuperview()
        countDownLabelSetAndRun()
        componentIsEnabled(parameter: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        countDownLabelSetAndRun()
        componentIsEnabled(parameter: false)
        
        ////////////////////////
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)

        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            
            let deltaY = intersection.height
            
            if keyBoardNeedLayout {
                UIView.animate(withDuration: duration, delay: 0.0,
                               options: UIView.AnimationOptions(rawValue: curve),
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
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            
            let deltaY = intersection.height
            
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIView.AnimationOptions(rawValue: curve),
                           animations: {
                            self.view.frame = CGRect(x:0,y:deltaY / 2,width:self.view.bounds.width,height:self.view.bounds.height)
                            self.keyBoardNeedLayout = true
                            self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func textFieldSetting()
    {
        settedTextFieldsArray = textFieldsArray.map { (eachTextField) -> UITextField in
            eachTextField.keyboardType = .numberPad
            return eachTextField
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
        
        scoreBoardBtnOutlet.isEnabled = parameter
    }
    
    //MARK: Realm相關操作
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
    func loadScore()
    {
        allScore = currentUser.scores.filter("mode CONTAINS[cd] %@", "簡單模式").sorted(byKeyPath: "score", ascending: true)
        guard let scoreArray = allScore else {return}
        for (index,eachScore) in scoreArray.enumerated()
        {
            if index == 5{
                break
            }else{
                withinFiveScore.append(eachScore.score)
                print("score:",eachScore.score)
            }
            
        }
    }
    
    
}

extension EasyModeController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return withinFiveScore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scoreTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "第\(indexPath.row + 1)名:\(withinFiveScore[indexPath.row])"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Avenir", size: 30)
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return cell
    }
    
    
}
