//
//  StartViewController.swift
//  PitchHike
//
//  Created by NinjaSE3 on 2015/07/24.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//

import UIKit
class StartViewController: UIViewController {
  
  //時間計測用の変数.
  var limtime : Float = 30
  
  //時間表示用のラベル.
  var myLabel : UILabel!
  
  // Tableで使用する配列を設定する
  private var topicItems: [String] = [];
  private var myTableView: UITableView!
  
  private var studentImageView: UIImageView!
  private var teacherImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.createTimerView()
    self.createStartButton()
    self.createMatchingView()
  }
  
  func createTimerView(){
    //ラベルを作る.
    myLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.width,40))
    myLabel.backgroundColor = UIColor.blackColor()
    myLabel.layer.masksToBounds = true
    myLabel.text = "Time:".stringByAppendingFormat("%.0f",limtime)
    myLabel.textColor = UIColor.whiteColor()
    myLabel.textAlignment = NSTextAlignment.Center
    myLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 50)
    self.view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(myLabel)
  }
  
  func createStartButton(){
    // ボタンの生成.
    let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
    myButton.backgroundColor = UIColor.orangeColor()
    myButton.layer.masksToBounds = true
    myButton.setTitle("START", forState: .Normal)
    myButton.layer.cornerRadius = 5.0
    myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/1.2)
    myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
    self.view.addSubview(myButton)
  }
  
  
  // ボタンイベントのセット.
  func onClickMyButton(sender: UIButton){
    
    // ピッチを開始リクエスト
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var startPitch:JSON = self.startPitching(appDelegate._requestStatusID!)
//    var startPitch:JSON = self.startPitching("559b673c6a97fd654ea0955f")
    
    // 互いに開始を押すまで繰り返す。
    // 現在日時を取得
    var date1 = NSDate()
    while(true){
      var startPitch:JSON = self.startPitching(appDelegate._requestStatusID!)
//      var startPitch:JSON = self.startPitching("559b673c6a97fd654ea0955f")

      println(startPitch["status"])
      
      sleep(1)
      // 現在日時を取得
      var date2 = NSDate()
      var time  = Float(date2.timeIntervalSinceDate(date1))
      println(time)
      
      var status:String = startPitch["status"].toString(pretty: true)
      if( startPitch["status"].toString(pretty: true) == "start" ){
        break
      }
      if(time > Float(5)){
        appDelegate._error = "TimeOut"
        break
      }
    }
    if(appDelegate._error != "TimeOut"){
      // 遷移するViewを定義する.
      let pitchViewController: UIViewController = PitchViewController()
      // アニメーションを設定する.
      pitchViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
      // Viewの移動する.
      self.presentViewController(pitchViewController, animated: true, completion: nil)
    }else{
      print("ピッチ開始失敗")
    }
    
  }
  
  func createMatchingView(){
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var requestStatus = appDelegate._requestStatusID
//    var requestStatus = "559b673c6a97fd654ea0955f"
    println(requestStatus)
    
    var student:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus!)["student"]).toString(pretty: true))
    
    var teacher:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus!)["teacher"]).toString(pretty: true))
    
    // StudentPhoto
    // UIImageViewを作成する.
    studentImageView = UIImageView(frame: CGRectMake(0,0,100,100))
    // 表示する画像を設定する.
    let studentImage = UIImage(data: self.getImage(JSON(student["image"]).toString(pretty: true)))
    // 画像をUIImageViewに設定する.
    studentImageView.image = studentImage
    // 画像の表示する座標を指定する.
    studentImageView.layer.position = CGPoint(x: self.view.bounds.width/3, y: self.view.bounds.height/2)
    // UIImageViewをViewに追加する.
    self.view.addSubview(studentImageView)
    
    // Strudent Name
    let studentPhoto = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    studentPhoto.backgroundColor = UIColor.blueColor()
    studentPhoto.layer.masksToBounds = true
    studentPhoto.setTitle(JSON(student["name"]).toString(pretty: true), forState: .Normal)
    studentPhoto.layer.cornerRadius = 10.0
    studentPhoto.layer.position = CGPoint(x: self.view.bounds.width/3, y:self.view.bounds.height/1.65)
    self.view.addSubview(studentPhoto)
    
    // TeacherPhoto
    // UIImageViewを作成する.
    teacherImageView = UIImageView(frame: CGRectMake(0,0,100,100))
    // 表示する画像を設定する.
    let teacherImage = UIImage(data: self.getImage(JSON(teacher["image"]).toString(pretty: true)))
    // 画像をUIImageViewに設定する.
    teacherImageView.image = teacherImage
    // 画像の表示する座標を指定する.
    teacherImageView.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3, y: self.view.bounds.height/2)
    // UIImageViewをViewに追加する.
    self.view.addSubview(teacherImageView)
    
    // Teacher Name
    let teacherPhoto = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    teacherPhoto.backgroundColor = UIColor.redColor()
    teacherPhoto.layer.masksToBounds = true
    teacherPhoto.setTitle(JSON(teacher["name"]).toString(pretty: true), forState: .Normal)
    teacherPhoto.layer.cornerRadius = 10.0
    teacherPhoto.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3, y:self.view.bounds.height/1.65)
    self.view.addSubview(teacherPhoto)
    
  }
  
  func getRequestStatus(requestStatus:String) -> JSON{
    var getRequestStatusURL = "http://52.8.212.125/getRequestStatus?_id=" + requestStatus
    let requestStatus = JSON(url: getRequestStatusURL)
    println(getRequestStatusURL)
    println(requestStatus)
    return requestStatus
  }
  
  func getUser(requestUserId:String) -> JSON{
    var getUserURL = "http://52.8.212.125/getUser?userid=" + requestUserId
    let userRes = JSON(url: getUserURL)
    println(getUserURL)
    println(userRes)
    return userRes
  }
  
  func startPitching(requestStatusID:String) -> JSON{
    var startPitchingURL = "http://52.8.212.125/startPitching?_id=" + requestStatusID
    let startPitchingRes = JSON(url: startPitchingURL)
    println(startPitchingURL)
    println(startPitchingRes)
    return startPitchingRes
  }
  
  func getImage(image:String)->NSData{
    let url = NSURL(string: "http://52.8.212.125/getImage?url=" + image);
    var err: NSError?;
    var getImageRes :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!;
    return getImageRes
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}