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
    //MARK: - 加入畫面處理
    func setUpConstraints_Pause(view: UIView)
    {
        view.addSubview(newPauseView)
        newPauseView.addSubview(newPauseBtn)
        
        newPauseView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        newPauseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        newPauseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        newPauseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        
        newPauseBtn.centerXAnchor.constraint(equalTo: newPauseView.centerXAnchor).isActive = true
        newPauseBtn.centerYAnchor.constraint(equalTo: newPauseView.centerYAnchor).isActive = true
    }
    
    func setUpConstraints_ScoreBoard_NoScore(view: UIView){
        view.addSubview(newPauseView)
        newPauseView.addSubview(newCancelBtn)
        newPauseView.addSubview(newScoreEmptyLabel)
        
        
        newPauseView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        newPauseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        newPauseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        newPauseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        
        newCancelBtn.topAnchor.constraint(equalTo: newPauseView.topAnchor, constant: 20).isActive = true
        newCancelBtn.rightAnchor.constraint(equalTo: newPauseView.rightAnchor, constant: -20).isActive = true
        newCancelBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 50.0 / 414.0).isActive = true
        newCancelBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 50.0 / 736.0).isActive = true
        
        newScoreEmptyLabel.centerXAnchor.constraint(equalTo: newPauseView.centerXAnchor).isActive = true
        newScoreEmptyLabel.centerYAnchor.constraint(equalTo: newPauseView.centerYAnchor).isActive = true
        newScoreEmptyLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        newScoreEmptyLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 100.0 / 736.0).isActive = true
    }
    func setUpConstraints_ScoreBoard(view: UIView){
        view.addSubview(newPauseView)
        newPauseView.addSubview(newCancelBtn)
        newPauseView.addSubview(newScoreTableView)
        newPauseView.addSubview(newBestTimeLabel)
        ///
        newPauseView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        newPauseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        newPauseView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        newPauseView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        ///
        newCancelBtn.topAnchor.constraint(equalTo: newPauseView.topAnchor, constant: 20).isActive = true
        newCancelBtn.rightAnchor.constraint(equalTo: newPauseView.rightAnchor, constant: -20).isActive = true
        newCancelBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 50.0 / 414.0).isActive = true
        newCancelBtn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 50.0 / 736.0).isActive = true
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
    func setUpConstraints_CountDownLabel(view: UIView){
        view.addSubview(newCountDownLabel)
        newCountDownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newCountDownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        newCountDownLabel.text = "3"
        
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
}


