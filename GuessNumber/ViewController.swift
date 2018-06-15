//
//  ViewController.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/6/2.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import UIKit
import CountdownLabel

class ViewController: UIViewController {
    @IBOutlet weak var easyModeBtn: UIButton!
    @IBOutlet weak var hardModeBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var regulationBtn: UIButton!
    var mainPageController = MainPage()
    var pauseView = UIView()
    var cancelBtn = UIButton()
    var regulation = UILabel()
    @IBAction func getStart(_ sender: UIButton) {
    }
    
    @IBAction func exitApp(_ sender: UIButton) {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        //執行CountDownTimer
    }
    @IBAction func regulationBtn(_ sender: UIButton) {
        let frame = CGRect(x:0,y:20,width:self.view.frame.width,height:self.view.frame.height)
        pauseView = UIView(frame: frame)
        pauseView.backgroundColor = UIColor.black
        pauseView.alpha = 0.5
        self.view.addSubview(pauseView)
        /////////////////////////////////
        let cancelBtnImage = UIImage(named: "cancel.png")
        let cancelBtnframe = CGRect(x:self.view.frame.width - 60,
                                    y:40,
                                    width:(cancelBtnImage?.size.width)!,
                                    height:(cancelBtnImage?.size.height)!)
        cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(cancelBtnImage, for: .normal)
        cancelBtn.frame = cancelBtnframe
        cancelBtn.addTarget(self, action: #selector(self.cancelRegulation), for: .touchUpInside)
        pauseView.addSubview(cancelBtn)
        //////////////////////////////////////////
        regulation.text = "規則說明\n\n遊戲開始時會產生1-4隨機排列的組合\n玩家必須猜測並輸入\n簡單模式為不重複數字(24種組合)\n困難模式則會重複(256種組合)"
        regulation.font = regulation.font.withSize(30.0)
        //不限制行數
        regulation.numberOfLines = 0
        //regulation.lineBreakMode = .byWordWrapping
        //////////////////////////////////////////
        regulation.textAlignment = .center
        regulation.textColor = UIColor.white
        //regulation.backgroundColor = UIColor.red
        let regulationFrame = CGRect(x: 60, y: 70, width: self.view.frame.width - 120, height: self.view.frame.height - 140)
        regulation.frame = regulationFrame
        pauseView.addSubview(regulation)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setBtnRadius()
        print("width:\(self.view.frame.width)  height:\(self.view.frame.height)")
    }
    override func viewDidDisappear(_ animated: Bool) {
        //mainPageController.runCountDownTimer()
        print("disappear")
    }
    func setBtnRadius()
    {
        easyModeBtn.layer.cornerRadius = 10.0
        hardModeBtn.layer.cornerRadius = 10.0
        exitBtn.layer.cornerRadius = 10.0
        regulationBtn.layer.cornerRadius = 10.0
    }
    @objc func cancelRegulation()
    {
        cancelBtn.removeFromSuperview()
        regulation.removeFromSuperview()
        pauseView.removeFromSuperview()
    }
}
