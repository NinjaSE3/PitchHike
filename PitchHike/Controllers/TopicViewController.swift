//
//  TopicViewController.swift
//  PitchHike
//
//  Created by Takaaki on 2015/07/22.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//


import UIKit
class TopicViewController: UIViewController {
  
  //時間計測用の変数.
  var limtime : Float = 30
  
  //時間表示用のラベル.
  var myLabel : UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.createView()
    self.createButton()
  }
  
  func createView(){
    //ラベルを作る.
    myLabel = UILabel(frame: CGRectMake(0,0,200,50))
    myLabel.backgroundColor = UIColor.whiteColor()
    myLabel.layer.masksToBounds = true
    myLabel.layer.cornerRadius = 20.0
    myLabel.text = "Time:".stringByAppendingFormat("%.0f",limtime)
    myLabel.textColor = UIColor.blackColor()
    myLabel.shadowColor = UIColor.grayColor()
    myLabel.textAlignment = NSTextAlignment.Center
    myLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 200)
    self.view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(myLabel)
  }
  
  func createButton(){
    // ボタンの生成.
    let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    myButton.backgroundColor = UIColor.orangeColor()
    myButton.layer.masksToBounds = true
    myButton.setTitle("START", forState: .Normal)
    myButton.layer.cornerRadius = 50.0
    myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2)
    myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
    self.view.addSubview(myButton)
  }
  
  
  // ボタンイベントのセット.
  func onClickMyButton(sender: UIButton){
    // Start
    self.start()
  }
  
  
  func start(){
    //タイマーを作る.
    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
  }
  
  //NSTimerIntervalで指定された秒数毎に呼び出されるメソッド.
  func onUpdate(timer : NSTimer){
    limtime = limtime - 1
    //桁数を指定して文字列を作る.
    if(limtime > Float(-1)){
      let str = "Time:".stringByAppendingFormat("%.0f",limtime)
      myLabel.text = str
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}