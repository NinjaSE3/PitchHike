//
//  ProfileViewController.swift
//  PitchHike
//
//  Created by NinjaSE3 on 2015/07/24.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//

import UIKit
class ProfileViewController: UIViewController {
  
  //時間表示用のラベル.
  var timeLabel : UILabel!
  
  private var teacherImageView: UIImageView!
  
  // 配色
  private var secondaryText:UIColor!
  private var primaryText:UIColor!
  private var accentColor:UIColor!
  private var darkPrimaryColor:UIColor!
  private var primaryColor:UIColor!
  private var lightPrimaryColor:UIColor!
  private var textIcons:UIColor!
  private var dividerColor:UIColor!
  
  
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
    
    self.view.backgroundColor = textIcons
    self.createTimerView()
    //self.createBackView()
    self.createProfileView()
  }
  
  func createTimerView(){
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //    var requestStatus:JSON = self.getRequestStatus(appDelegate._requestStatusID)
    var requestStatus:JSON = self.getRequestStatus("559b6ac9e8deb3a44e12fc93")
    
    //ラベルを作る.
    var limtime = 15
    timeLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.width,self.navigationController!.navigationBar.bounds.size.height))
    timeLabel.backgroundColor = primaryColor
    timeLabel.textColor = textIcons
    timeLabel.layer.masksToBounds = true
    if(JSON(requestStatus["arrive"]).toString(true) != ""){
      timeLabel.text = "Time:"+JSON(requestStatus["arrive"]).toString(true)
    }
    timeLabel.textColor = UIColor.whiteColor()
    timeLabel.textAlignment = NSTextAlignment.Center
    timeLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: self.navigationController!.navigationBar.bounds.size.height*2)
    self.view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(timeLabel)
    
  }
  /*
  func createBackView(){
    // ボタンの生成.
    let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width,height: self.navigationController!.navigationBar.bounds.size.height))
    myButton.backgroundColor = lightPrimaryColor
    myButton.setTitleColor(primaryText, forState: .Normal)
    myButton.layer.masksToBounds = true
    myButton.setTitle("Profile", forState: .Normal)
    myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.navigationController!.navigationBar.bounds.size.height*3)
    myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
    self.view.addSubview(myButton)
  }
  */
  
  // ボタンイベントのセット.
  func onClickMyButton(sender: UIButton){
    //戻り処理
  }
  
  func createProfileView(){
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var requestStatus = appDelegate._requestStatusID
//    var requestStatus = "559b673c6a97fd654ea0955f"

    var teacher:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus!)["teacher"]).toString(true))
    // TeacherPhoto
    // UIImageViewを作成する.
    teacherImageView = UIImageView(frame: CGRectMake(0,0,100,100))
    // 表示する画像を設定する.
    let teacherImage = UIImage(data: self.getImage(JSON(teacher["image"]).toString(true)))
    // 画像をUIImageViewに設定する.
    teacherImageView.image = teacherImage
    // 画像の表示する座標を指定する.
    teacherImageView.layer.position = CGPoint(x: self.view.bounds.width/4.8, y: self.view.bounds.height/3.6)
    // UIImageViewをViewに追加する.
    self.view.addSubview(teacherImageView)
    
    // Teacher FullName
    let teacherName = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    teacherName.setTitleColor(primaryText, forState: .Normal)
    teacherName.layer.masksToBounds = true
    teacherName.setTitle(JSON(teacher["fullname"]).toString(true), forState: .Normal)
    teacherName.layer.cornerRadius = 10.0
    teacherName.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
    teacherName.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3, y:self.view.bounds.height/3.6)
    self.view.addSubview(teacherName)

    // Teacher birthday
    let teacherBirthday = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 20))
    teacherBirthday.setTitleColor(primaryText, forState: .Normal)
    teacherBirthday.layer.masksToBounds = true
    teacherBirthday.setTitle("Birthday : " + JSON(teacher["birthday"]).toString(true), forState: .Normal)
    teacherBirthday.layer.cornerRadius = 10.0
    teacherBirthday.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
    teacherBirthday.layer.position = CGPoint(x:self.view.bounds.width/2 + 15, y:self.view.bounds.height/4 + 100)
    self.view.addSubview(teacherBirthday)

    // Teacher hobby
    let teacherHobby = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 20))
    teacherHobby.setTitleColor(primaryText, forState: .Normal)
    teacherHobby.layer.masksToBounds = true
    teacherHobby.setTitle("Hobby : " + JSON(teacher["hobby"]).toString(true), forState: .Normal)
    teacherHobby.layer.cornerRadius = 10.0
    teacherHobby.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
    teacherHobby.layer.position = CGPoint(x: self.view.bounds.width/2 + 15, y:self.view.bounds.height/4 + 150)
    self.view.addSubview(teacherHobby)
    
    // Teacher job
    let teacherJob = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 20))
    teacherJob.setTitleColor(primaryText, forState: .Normal)
    teacherJob.layer.masksToBounds = true
    teacherJob.setTitle("Job : " + JSON(teacher["job"]).toString(true), forState: .Normal)
    teacherJob.layer.cornerRadius = 10.0
    teacherJob.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
    teacherJob.layer.position = CGPoint(x: self.view.bounds.width/2 + 15, y:self.view.bounds.height/4 + 200)
    self.view.addSubview(teacherJob)
    
    // Teacher dream
    let teacherDream = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 20))
    teacherDream.setTitleColor(primaryText, forState: .Normal)
    teacherDream.layer.masksToBounds = true
    teacherDream.setTitle("Dream : " + JSON(teacher["dream"]).toString(true), forState: .Normal)
    teacherDream.layer.cornerRadius = 10.0
    teacherDream.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
    teacherDream.layer.position = CGPoint(x: self.view.bounds.width/2 + 15, y:self.view.bounds.height/4 + 250)
    self.view.addSubview(teacherDream)

    
  }
  
  func getRequestStatus(requestStatusID:String) -> JSON{
    let getRequestStatusURL = "http://localhost:8080/getRequestStatus?_id=" + requestStatusID
    let requestStatus = JSON(url: getRequestStatusURL)
    print(getRequestStatusURL)
    print(requestStatus)
    return requestStatus
  }

  func getTopics() -> JSON{
    let getTopicsURL = "http://localhost:8080/getTopics"
    let topicsRes = JSON(url: getTopicsURL)
    print(getTopicsURL)
    print(topicsRes)
    return topicsRes
  }

  func getUser(requestUserId:String) -> JSON{
    let getUserURL = "http://localhost:8080/getUser?userid=" + requestUserId
    let userRes = JSON(url: getUserURL)
    print(getUserURL)
    print(userRes)
    return userRes
  }
  
  func getImage(image:String)->NSData{
    let url = NSURL(string: "http://localhost:8080/getImage?url=" + image);
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
