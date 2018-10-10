//
//  HardModeController.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/6/16.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import UIKit
import GameKit
import RealmSwift
class HardModeController: UIViewController {

    var seconds  = 3
    var gameTimer = Timer()
    var countDowntimer = Timer()
    
    var withinFiveScore = [String]()
    //純加入
    var textFieldsArray = [UITextField]()
    //加入設定後
    var settedTextFieldsArray = [UITextField]()
    var showScore: String = ""
    /////////////////////////////
    var timerHandle = TimerHandle()
    var regulationHandle = RegulationHandle()
    var customView = CustomView()
    var keyBoardNeedLayout: Bool = true
    
    var currentUser = User()
    let realm = try! Realm()
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
    @IBOutlet weak var scoreBoardBtnOutlet: UIButton!
    @IBAction func checkBtn(_ sender: UIButton) {
        
        //如果inputArray是空的則不用清空,直接append
        //每次check前先將 right &  wrong計數器歸0
        if regulationHandle.inputArray.isEmpty{
            checkAnserHandler()
        }
        else{
            regulationHandle.inputArray.removeAll()
            checkAnserHandler()
        }
        
    }
    @IBAction func scoreBoardBtn(_ sender: UIButton) {
        loadScore()
        gameTimer.invalidate()
        setUpConstraints_ScoreBoard()
    }
    
    @IBAction func pauseBtn(_ sender: UIButton) {
        //遊戲計時停止
        gameTimer.invalidate()
        setUpConstraints_Pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regulationHandle.RepeatNumbers()
        textFieldsArray.append(inputNo1)
        textFieldsArray.append(inputNo2)
        textFieldsArray.append(inputNo3)
        textFieldsArray.append(inputNo4)
        textFieldSetting()
        
        customView.newScoreTableView.delegate  = self
        customView.newScoreTableView.dataSource = self
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        countDownLabelSetAndRun()
        componentIsEnabled(parameter: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
   
    // MARK: 遊戲規則處理
    func checkAnserHandler()
    {
        regulationHandle.right = 0
        regulationHandle.wrong = 0
        addUserInputToArray()
        updateRightAndWrong()
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
    func updateRightAndWrong()
    {
        //如果四個輸入框都有值
        if (regulationHandle.inputArray.count == 4)
        {
            
            if regulationHandle.checkNumberIsCorrect().right == 4
            {
                rightCount.text = String(regulationHandle.right)
                wrongCount.text = String(regulationHandle.wrong)
                simpleHint()
                gameTimer.invalidate()
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
        regulationHandle.RepeatNumbers()

        rightCount.text = "0"
        wrongCount.text = "0"
        timerLabel.text = "0.0"

        for i in 0...settedTextFieldsArray.count - 1
        {
            settedTextFieldsArray[i].text = ""
        }
        timerHandle.counter = 00.0
        gameTimer.invalidate()
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
        
        // 建立[確認]按鈕
        let okAction = UIAlertAction(
            title: "離開",
            style: .default,
            handler: {
                (action: UIAlertAction!) -> Void in
                self.addScore(gameScore: self.timerLabel.text!)
                self.dismiss(animated: true, completion: nil)
                
        })
        alertController.addAction(okAction)
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "重新開始",
            style: .cancel,
            handler: {
                (action: UIAlertAction!) -> Void in
                self.addScore(gameScore: self.timerLabel.text!)
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
        gameTimer.invalidate()
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
        customView.removeConstraints_Pause()
        countDownLabelSetAndRun()
        componentIsEnabled(parameter: false)
        
        
    }
    // MARK: 計時處理
    @objc func UpdateTimer() {
        timerLabel.text = timerHandle.UpdateTimer()
    }
    func runGameTimer()
    {
        //開始計時
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    func runCountDownTimer() {
        countDowntimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.countDown)), userInfo: nil, repeats: true)
        
        
    }
    @objc func countDown() {
        seconds -= 1     //This will decrement(count down)the seconds.
        customView.newCountDownLabel.text = "\(seconds)" //This will update the label.
        if (seconds == 0)
        {
            componentIsEnabled(parameter: true)
            countDowntimer.invalidate()
            customView.removeConstraints_CountDownLabel()
            runGameTimer()
            seconds = 3
            
        }
    }
    // MARK: 手動加入UIFrame
    func countDownLabelSetAndRun()
    {
        customView.setUpConstraints_CountDownLabel(with: self.view)
        runCountDownTimer()
    }
    //MARK: - 設定Constraint
    func setUpConstraints_Pause()
    {
        customView.setUpConstraints_Pause(with: self.view)
        customView.newPauseBtn.addTarget(self, action: #selector(self.playButton), for: .touchUpInside)
    }
    func setUpConstraints_ScoreBoard()
    {
        if withinFiveScore.isEmpty{
            customView.setUpConstraints_ScoreBoard_NoScore(with: self.view)
            customView.newCancelBtn.addTarget(self, action: #selector(self.cancelScoreBoard), for: .touchUpInside)
        }else{
            customView.setUpConstraints_ScoreBoard(with: self.view)
            customView.newCancelBtn.addTarget(self, action: #selector(self.cancelScoreBoard), for: .touchUpInside)
        }


    }
    
    
    @objc func cancelScoreBoard()
    {
        if withinFiveScore.isEmpty{
            customView.removeConstraints_ScoreBoard_NoScore()
            countDownLabelSetAndRun()
            componentIsEnabled(parameter: false)
        }else{
            customView.removeConstraints_ScoreBoard()
            countDownLabelSetAndRun()
            componentIsEnabled(parameter: false)
        }
    }
    
    // MARK: 鍵盤事件處理
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
    //點擊背景可收回鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    //MArk: Realm相關操作
    func addScore(gameScore: String)
    {
        let newScore = Score()
        newScore.score  = gameScore
        newScore.mode = "困難模式"
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
        //防止累加
        if withinFiveScore.isEmpty{
            getScoresFromRealm()
            customView.newScoreTableView.reloadData()
        }else{
            withinFiveScore.removeAll()
            getScoresFromRealm()
            customView.newScoreTableView.reloadData()
        }
        
        
    }
    func getScoresFromRealm(){
        showScore = ""
        allScore = currentUser.scores.filter("mode CONTAINS[cd] %@", "困難模式").sorted(byKeyPath: "score", ascending: true)
        for (index,eachScore) in allScore!.enumerated()
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
extension HardModeController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return withinFiveScore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customView.newScoreTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "第\(indexPath.row + 1)名:\(withinFiveScore[indexPath.row])"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Avenir", size: 30)
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return cell
    }
    
    
}
