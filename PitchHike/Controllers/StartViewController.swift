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
  
  // 配色
  private var secondaryText:UIColor!
  private var primaryText:UIColor!
  private var accentColor:UIColor!
  private var darkPrimaryColor:UIColor!
  private var primaryColor:UIColor!
  private var lightPrimaryColor:UIColor!
  private var textIcons:UIColor!
  private var dividerColor:UIColor!
  
  // Tableで使用する配列を設定する
  private var topicItems: [String] = [];
  private var myTableView: UITableView!
  
  private var studentImageView: UIImageView!
  private var teacherImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    secondaryText = UIColorFromRGB(0x727272);
    primaryText = UIColorFromRGB(0x212121);
    accentColor = UIColorFromRGB(0xFF4081);
    darkPrimaryColor = UIColorFromRGB(0x0288D1);
    primaryColor = UIColorFromRGB(0x03A9F4);
    lightPrimaryColor = UIColorFromRGB(0xB3E5FC);
    textIcons = UIColorFromRGB(0xF8F8F8);
    dividerColor = UIColorFromRGB(0xB6B6B6);
    
    self.createTimerView()
    self.createStartButton()
    self.createMatchingView()
  }
  
  func createTimerView(){
    //ラベルを作る.
    myLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.width,40))
    myLabel.backgroundColor = primaryColor
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
    myButton.backgroundColor = accentColor
    myButton.layer.masksToBounds = true
    myButton.setTitle("START", forState: .Normal)
    myButton.layer.cornerRadius = 5.0
    myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2.4)
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

      print(startPitch["status"])
      
      sleep(1)
      // 現在日時を取得
      var date2 = NSDate()
      var time  = Float(date2.timeIntervalSinceDate(date1))
      print(time)
      
      var status:String = startPitch["status"].toString(true)
      if( startPitch["status"].toString(true) == "start" ){
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
      pitchViewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
      // Viewの移動する.
      self.presentViewController(pitchViewController, animated: true, completion: nil)
    }else{
      print("ピッチ開始失敗", terminator: "")
    }
    
  }
  
  func createMatchingView(){
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var requestStatus = appDelegate._requestStatusID
//    var requestStatus = "559b673c6a97fd654ea0955f"
    print(requestStatus)
    
    var student:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus!)["student"]).toString(true))
    
    var teacher:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus!)["teacher"]).toString(true))
    
    // StudentPhoto
    // UIImageViewを作成する.
    studentImageView = UIImageView(frame: CGRectMake(0,0,100,100))
    // 表示する画像を設定する.
    let studentImage = UIImage(data: self.getImage(JSON(student["image"]).toString(true)))
    // 画像をUIImageViewに設定する.
    studentImageView.image = studentImage
    // 画像の表示する座標を指定する.
    studentImageView.layer.position = CGPoint(x: self.view.bounds.width/3.2, y: self.view.bounds.height/4.2)
    // UIImageViewをViewに追加する.
    self.view.addSubview(studentImageView)
    
    // Strudent Name
    let studentName = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    //studentName.backgroundColor = UIColor.blueColor()
    studentName.setTitleColor(primaryText, forState: .Normal)
    studentName.layer.masksToBounds = true
    studentName.setTitle(JSON(student["name"]).toString(true), forState: .Normal)
    studentName.layer.cornerRadius = 10.0
    studentName.layer.position = CGPoint(x: self.view.bounds.width/3.2, y:self.view.bounds.height/3)
    self.view.addSubview(studentName)
    
    // TeacherPhoto
    // UIImageViewを作成する.
    teacherImageView = UIImageView(frame: CGRectMake(0,0,100,100))
    // 表示する画像を設定する.
    let teacherImage = UIImage(data: self.getImage(JSON(teacher["image"]).toString(true)))
    // 画像をUIImageViewに設定する.
    teacherImageView.image = teacherImage
    // 画像の表示する座標を指定する.
    teacherImageView.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3.2, y: self.view.bounds.height/4.2)
    // UIImageViewをViewに追加する.
    self.view.addSubview(teacherImageView)
    
    // Teacher Name
    let teacherName = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    //teacherName.backgroundColor = UIColor.redColor()
    teacherName.setTitleColor(primaryText, forState: .Normal)
    teacherName.layer.masksToBounds = true
    teacherName.setTitle(JSON(teacher["name"]).toString(true), forState: .Normal)
    teacherName.layer.cornerRadius = 10.0
    teacherName.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3.2, y:self.view.bounds.height/3)
    self.view.addSubview(teacherName)
    
  }
  
  func getRequestStatus(requestStatus:String) -> JSON{
    let getRequestStatusURL = "http://52.8.212.125/getRequestStatus?_id=" + requestStatus
    let requestStatus = JSON(url: getRequestStatusURL)
    print(getRequestStatusURL)
    print(requestStatus)
    return requestStatus
  }
  
  func getUser(requestUserId:String) -> JSON{
    let getUserURL = "http://52.8.212.125/getUser?userid=" + requestUserId
    let userRes = JSON(url: getUserURL)
    print(getUserURL)
    print(userRes)
    return userRes
  }
  
  func startPitching(requestStatusID:String) -> JSON{
    let startPitchingURL = "http://52.8.212.125/startPitching?_id=" + requestStatusID
    let startPitchingRes = JSON(url: startPitchingURL)
    print(startPitchingURL)
    print(startPitchingRes)
    return startPitchingRes
  }
  
  func getImage(image:String)->NSData{
    let url = NSURL(string: "http://52.8.212.125/getImage?url=" + image);
    var err: NSError?;
    let getImageRes :NSData = try! NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe);
    return getImageRes
  }
  
  //UIntに16進で数値をいれるとUIColorが戻る関数
  func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}