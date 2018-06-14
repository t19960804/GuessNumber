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
    var mainPageController = MainPage()
    @IBAction func getStart(_ sender: UIButton) {
    }
    
    @IBAction func exitApp(_ sender: UIButton) {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        //執行CountDownTimer
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        //mainPageController.runCountDownTimer()
        print("disappear")
    }
}
