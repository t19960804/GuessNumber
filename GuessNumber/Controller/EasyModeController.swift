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
    //純加入
    var textFieldsArray = [UITextField]()
    //加入設定後
    var settedTextFieldsArray = [UITextField]()
    
    var counter  = Float()
    var minuteCount = 0
    
    //MARK: - 自訂元件
    let newPauseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.alpha = 0.7
        return view
    }()
    let newPauseBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(named: "playbutton.png")
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    let newCancelBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttomImage = UIImage(named: "cancel.png")
        button.setImage(buttomImage, for: .normal)
        return button
    }()
    let newBestTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "最佳時間"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = label.font.withSize(40.0)
        return label
    }()
    let newScoreTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.black
        tableView.alpha = 0.5
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    let newCountDownLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(red: 1.0, green: 188/255, blue: 0.0, alpha: 1.0)
        label.font = label.font.withSize(250.0)
        label.text = "3"
        return label
    }()
    /////////////////////////////
    var countDownLabel = UILabel()
    var keyBoardNeedLayout: Bool = true
    let device = UIDevice.current
    let emailFromFaceBook = String()
    let realm = try! Realm()
    var currentUser = User()
    var allScore: Results<Score>?
    var withinFiveScore = [String]()
    var regulationHandle = RegulationHandle()
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
        if regulationHandle.inputArray.isEmpty
        {
            checkAnserHandler()
        }
        else
            
        {
            regulationHandle.inputArray.removeAll()
            checkAnserHandler()
        }
       
    }
    
    @IBAction func pauseBtn(_ sender: UIButton) {
        //遊戲計時停止
        timer.invalidate()
        self.view.addSubview(newPauseView)
        self.newPauseView.addSubview(newPauseBtn)
        setUpConstraints_Pause()
        
    }
    @IBAction func scoreBoardBtn(_ sender: UIButton) {
        timer.invalidate()
        self.view.addSubview(newPauseView)
        self.newPauseView.addSubview(newCancelBtn)
        self.newPauseView.addSubview(newBestTimeLabel)
        self.newPauseView.addSubview(newScoreTableView)
        setUpConstraints_ScoreBoard()

        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //noRepeatNumbers()
        regulationHandle.noRepeatNumbers()
        textFieldsArray.append(inputNo1)
        textFieldsArray.append(inputNo2)
        textFieldsArray.append(inputNo3)
        textFieldsArray.append(inputNo4)
        textFieldSetting()
        loadScore()
        newScoreTableView.delegate  = self
        newScoreTableView.dataSource = self
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //點擊背景可收回鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK: - 遊戲規則處理
    func checkAnserHandler()
    {
        regulationHandle.right = 0
        regulationHandle.wrong = 0
        addUserInputToArray()
        checkNumberIsCorrect()
    }
    
    //將textField的數字加入陣列
    func addUserInputToArray()
    {
        for i in 0...settedTextFieldsArray.count - 1
        {
            if (settedTextFieldsArray[i].text != "")
            {
            //加入使用者輸入數字
            regulationHandle.inputArray.append(Int(settedTextFieldsArray[i].text!)!)
            }
            else{
                
                break
            }
            
        }
    }
    
    func checkNumberIsCorrect()
    {
        //如果四個輸入框都有值
        if (regulationHandle.inputArray.count == 4)
        {
            regulationHandle.checkNumberIsCorrect()
            if regulationHandle.right == 4
            {
                rightCount.text = String(regulationHandle.right)
                wrongCount.text = String(regulationHandle.wrong)
                simpleHint()
                timer.invalidate()
            }else{
                rightCount.text = String(regulationHandle.right)
                wrongCount.text = String(regulationHandle.wrong)
                return
            }
        }
        //有一個值沒有就顯示提示
        else
        {
            textNilHint()
        }
    }
    //重新產生亂數,並且清空textField / randomArray / inputArray
    func resumeGame()
    {

        regulationHandle.resumeArrays()
        rightCount.text = "0"
        wrongCount.text = "0"
        timerLabel.text = "0.0"

        for i in 0...settedTextFieldsArray.count - 1
        {
            settedTextFieldsArray[i].text = ""
        }
        counter = 00.0
        timer.invalidate()
        countDownLabelSetAndRun()
        componentIsEnabled(parameter: false)
        
    }
    // MARK:- 系統提示
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
                self.countDownLabelSetAndRun()
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
        self.newPauseBtn.removeFromSuperview()
        self.newPauseView.removeFromSuperview()
        countDownLabelSetAndRun()
        componentIsEnabled(parameter: false)
        

    }
    // MARK: - 計時處理
    func runGameTimer()
    {
        //開始計時
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    func runCountDownTimer() {
        newCountDownLabel.text = "3"
        countDowntimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.countDown)), userInfo: nil, repeats: true)
       
        
    }
    @objc func countDown() {
        seconds -= 1     //This will decrement(count down)the seconds.
        newCountDownLabel.text = "\(seconds)" //This will update the label.
        if (seconds == 0)
        {
            componentIsEnabled(parameter: true)
            countDowntimer.invalidate()
            self.newCountDownLabel.removeFromSuperview()
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
        self.view.addSubview(newCountDownLabel)
        newCountDownLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        newCountDownLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        runCountDownTimer()
    }
    //MARK: - 設定Constraint
    func setUpConstraints_Pause()
    {
        newPauseView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        newPauseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        newPauseView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        newPauseView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        
        newPauseBtn.centerXAnchor.constraint(equalTo: newPauseView.centerXAnchor).isActive = true
        newPauseBtn.centerYAnchor.constraint(equalTo: newPauseView.centerYAnchor).isActive = true
        newPauseBtn.addTarget(self, action: #selector(self.playButton), for: .touchUpInside)
    }
    func setUpConstraints_ScoreBoard()
    {
        newPauseView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        newPauseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        newPauseView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        newPauseView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        
        newCancelBtn.topAnchor.constraint(equalTo: newPauseView.topAnchor, constant: 20).isActive = true
        newCancelBtn.rightAnchor.constraint(equalTo: newPauseView.rightAnchor, constant: -20).isActive = true
        newCancelBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 50.0 / 414.0).isActive = true
        newCancelBtn.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 50.0 / 736.0).isActive = true
        newCancelBtn.addTarget(self, action: #selector(self.cancelScoreBoard), for: .touchUpInside)
        
        newBestTimeLabel.centerXAnchor.constraint(equalTo: newPauseView.centerXAnchor).isActive = true
        newBestTimeLabel.bottomAnchor.constraint(equalTo: newScoreTableView.topAnchor, constant: 0).isActive = true
        newBestTimeLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 250.0 / 414.0).isActive = true
        newBestTimeLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 100.0 / 736.0).isActive = true
        
        newScoreTableView.centerXAnchor.constraint(equalTo: newPauseView.centerXAnchor).isActive = true
        newScoreTableView.centerYAnchor.constraint(equalTo: newPauseView.centerYAnchor).isActive = true
        newScoreTableView.widthAnchor.constraint(equalTo: self.newPauseView.widthAnchor).isActive = true
        newScoreTableView.heightAnchor.constraint(equalTo: self.newPauseView.heightAnchor, multiplier: 400.0 / 736.0).isActive = true


    }
    
    @objc func cancelScoreBoard()
    {
        self.newCancelBtn.removeFromSuperview()
        self.newBestTimeLabel.removeFromSuperview()
        self.newScoreTableView.removeFromSuperview()
        self.newPauseView.removeFromSuperview()
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
    // MARK: - 元件失效
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
    
    //MARK: - Realm相關操作
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
            }
            
        }
    }
    
    
}
//MARK: - Extension
extension EasyModeController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return withinFiveScore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newScoreTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "第\(indexPath.row + 1)名:\(withinFiveScore[indexPath.row])"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Avenir", size: 30)
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return cell
    }
    
    
}
