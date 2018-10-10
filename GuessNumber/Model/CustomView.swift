//
//  CustomView.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/10/4.
//  Copyright © 2018 t19960804. All rights reserved.
//

import Foundation
import UIKit



struct CustomView{
    
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
    let newScoreEmptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "目前尚無成績!"
        label.textAlignment = .center
        label.font = label.font.withSize(50.0)
        label.textColor = UIColor.white
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
    let newBestTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "最佳時間"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = label.font.withSize(40.0)
        return label
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
    let newRegulationView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.black
        textView.alpha = 0.7
        ///////////////
        let regulation = "規則說明\n\n遊戲開始時會產生1-4隨機排列的組合\n玩家必須猜測並輸入\n簡單模式為不重複數字\n(24種組合)\n困難模式則會重複\n(256種組合)"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        paragraphStyle.alignment = .center
        let attributes_Regulation = [NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                     NSAttributedString.Key.foregroundColor : UIColor.white,
                                     NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.medium)
                                    ]
        let attributedText_Regulation = NSAttributedString(string: regulation, attributes: attributes_Regulation)
        textView.attributedText = attributedText_Regulation
        return textView
    }()
    //MARK: - 加入畫面處理
    func setUpConstraints_Pause(with view: UIView)
    {
        view.addSubview(newPauseView)
        newPauseView.addSubview(newPauseBtn)
        setUpConstraints_PauseView(with: view)
        newPauseBtn.centerXAnchor.constraint(equalTo: newPauseView.centerXAnchor).isActive = true
        newPauseBtn.centerYAnchor.constraint(equalTo: newPauseView.centerYAnchor).isActive = true
    }
    
    func setUpConstraints_ScoreBoard_NoScore(with view: UIView){
        view.addSubview(newPauseView)
        newPauseView.addSubview(newCancelBtn)
        newPauseView.addSubview(newScoreEmptyLabel)
        setUpConstraints_PauseView(with: view)
        setUpConstraints_CancelBtn()
        
        newScoreEmptyLabel.centerXAnchor.constraint(equalTo: newPauseView.centerXAnchor).isActive = true
        newScoreEmptyLabel.centerYAnchor.constraint(equalTo: newPauseView.centerYAnchor).isActive = true
        newScoreEmptyLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        newScoreEmptyLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 100.0 / 736.0).isActive = true
    }
    func setUpConstraints_ScoreBoard(with view: UIView){
        view.addSubview(newPauseView)
        newPauseView.addSubview(newCancelBtn)
        newPauseView.addSubview(newScoreTableView)
        newPauseView.addSubview(newBestTimeLabel)
        setUpConstraints_PauseView(with: view)
        setUpConstraints_CancelBtn()
        ///
        newScoreTableView.centerXAnchor.constraint(equalTo: newPauseView.centerXAnchor).isActive = true
        newScoreTableView.centerYAnchor.constraint(equalTo: newPauseView.centerYAnchor).isActive = true
        newScoreTableView.widthAnchor.constraint(equalTo: self.newPauseView.widthAnchor).isActive = true
        newScoreTableView.heightAnchor.constraint(equalTo: self.newPauseView.heightAnchor, multiplier: 400.0 / 736.0).isActive = true
        ///
        newBestTimeLabel.centerXAnchor.constraint(equalTo: newPauseView.centerXAnchor).isActive = true
        newBestTimeLabel.bottomAnchor.constraint(equalTo: newScoreTableView.topAnchor, constant: 0).isActive = true
        newBestTimeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 250.0 / 414.0).isActive = true
        newBestTimeLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 100.0 / 736.0).isActive = true
    }
    func setUpConstraints_CountDownLabel(with view: UIView){
        view.addSubview(newCountDownLabel)
        newCountDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newCountDownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        newCountDownLabel.text = "3"
        
    }
    func setUpConstraints_Regulation(with view: UIView){
        view.addSubview(newPauseView)
        newPauseView.addSubview(newCancelBtn)
        newPauseView.addSubview(newRegulationView)
        
        setUpConstraints_PauseView(with: view)
        setUpConstraints_CancelBtn()
        newRegulationView.centerXAnchor.constraint(equalTo: newPauseView.centerXAnchor).isActive = true
        newRegulationView.centerYAnchor.constraint(equalTo: newPauseView.centerYAnchor).isActive = true
        newRegulationView.heightAnchor.constraint(equalTo: newPauseView.heightAnchor ,multiplier: 0.7).isActive = true
        newRegulationView.widthAnchor.constraint(equalTo: newPauseView.widthAnchor ,multiplier: 0.9).isActive = true
        
    }
    //MARK: - 單一元件
    func setUpConstraints_PauseView(with view: UIView){
        newPauseView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        newPauseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        newPauseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        newPauseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
    }
    func setUpConstraints_CancelBtn(){
        newCancelBtn.topAnchor.constraint(equalTo: newPauseView.topAnchor, constant: 20).isActive = true
        newCancelBtn.rightAnchor.constraint(equalTo: newPauseView.rightAnchor, constant: -20).isActive = true
        newCancelBtn.widthAnchor.constraint(equalTo: newPauseView.widthAnchor, multiplier: 50.0 / 414.0).isActive = true
        newCancelBtn.heightAnchor.constraint(equalTo: newPauseView.heightAnchor, multiplier: 50.0 / 736.0).isActive = true
    }
    //MARK: - 移除畫面處理
    func removeConstraints_Pause(){
        newPauseBtn.removeFromSuperview()
        newPauseView.removeFromSuperview()
    }
    func removeConstraints_ScoreBoard_NoScore(){
        newCancelBtn.removeFromSuperview()
        newPauseView.removeFromSuperview()
        newScoreEmptyLabel.removeFromSuperview()
    }
    func removeConstraints_ScoreBoard(){
        newCancelBtn.removeFromSuperview()
        newPauseView.removeFromSuperview()
        newScoreTableView.removeFromSuperview()
        newBestTimeLabel.removeFromSuperview()
    }
    func removeConstraints_CountDownLabel(){
        newCountDownLabel.removeFromSuperview()
    }
    func removeConstraints_Regulation(){
        newPauseView.removeFromSuperview()
        newCancelBtn.removeFromSuperview()
        newRegulationView.removeFromSuperview()
    }
}


