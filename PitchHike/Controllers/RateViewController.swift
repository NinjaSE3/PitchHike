//
//  RateViewController.swift
//  PitchHike
//
//  Created by NinjaSE3 on 2015/07/24.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//

import UIKit
class RateViewController: UIViewController {

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
    self.view.backgroundColor = UIColor.whiteColor()
    secondaryText = UIColorFromRGB(0x727272);
    primaryText = UIColorFromRGB(0x212121);
    accentColor = UIColorFromRGB(0xFF4081);
    darkPrimaryColor = UIColorFromRGB(0x0288D1);
    primaryColor = UIColorFromRGB(0x03A9F4);
    lightPrimaryColor = UIColorFromRGB(0xB3E5FC);
    textIcons = UIColorFromRGB(0xF8F8F8);
    dividerColor = UIColorFromRGB(0xB6B6B6);
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    appDelegate._requestStatusID = "559b673c6a97fd654ea0955f"

    
    self.createRateStar()
    self.createProfileView()
  }
  
  func createProfileView(){
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var requestStatus = appDelegate._requestStatusID
    
    var teacher:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus!)["teacher"]).toString(pretty: true))
    // TeacherPhoto
    // UIImageViewを作成する.
    teacherImageView = UIImageView(frame: CGRectMake(0,0,100,100))
    // 表示する画像を設定する.
    let teacherImage = UIImage(data: self.getImage(JSON(teacher["image"]).toString(pretty: true)))
    // 画像をUIImageViewに設定する.
    teacherImageView.image = teacherImage
    // 画像の表示する座標を指定する.
    teacherImageView.layer.position = CGPoint(x: self.view.bounds.width/3.6, y: self.view.bounds.height/3)
    // UIImageViewをViewに追加する.
    self.view.addSubview(teacherImageView)
    
    // Teacher FullName
    let teacherName = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    teacherName.setTitleColor(primaryText, forState: .Normal)
    teacherName.layer.masksToBounds = true
    teacherName.setTitle(JSON(teacher["fullname"]).toString(pretty: true), forState: .Normal)
    teacherName.layer.cornerRadius = 10.0
    teacherName.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/2.5, y:self.view.bounds.height/3)
    self.view.addSubview(teacherName)
    
    
    var topLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.width,40))
    topLabel.backgroundColor = primaryColor
    topLabel.textColor = textIcons
    topLabel.layer.masksToBounds = true
    topLabel.text = "Finish"
    topLabel.textAlignment = NSTextAlignment.Center
    topLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 50)
    self.view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(topLabel)
    
    var ratemsgLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.width,60))
    ratemsgLabel.backgroundColor = lightPrimaryColor
    ratemsgLabel.textColor = secondaryText
    ratemsgLabel.layer.masksToBounds = true
    ratemsgLabel.numberOfLines = 2;
    ratemsgLabel.text = "Did you enjoy communication?\nPlease give your feedback."
    ratemsgLabel.textAlignment = NSTextAlignment.Center
    ratemsgLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 100)
    self.view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(ratemsgLabel)
    
  }
  
  let rate1Star = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  let rate2Star = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  let rate3Star = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  let rate4Star = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  let rate5Star = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  
  func createRateStar(){
    // Rate 1 Star
    //let rate1Star = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    rate1Star.setTitleColor(secondaryText, forState: .Normal)
    rate1Star.layer.masksToBounds = true
    rate1Star.setTitle("★", forState: .Normal)
    rate1Star.titleLabel!.font = UIFont.systemFontOfSize(CGFloat(40))
    rate1Star.layer.cornerRadius = 10.0
    rate1Star.layer.position = CGPoint(x: self.view.bounds.width/2 - 100, y:self.view.bounds.height/4 + 200)
    rate1Star.addTarget(self, action: "onClickRate1Star:", forControlEvents: .TouchUpInside)
    self.view.addSubview(rate1Star)

    // Rate 1 Star
    //let rate2Star = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    rate2Star.setTitleColor(secondaryText, forState: .Normal)
    rate2Star.layer.masksToBounds = true
    rate2Star.setTitle("★", forState: .Normal)
    rate2Star.titleLabel!.font = UIFont.systemFontOfSize(CGFloat(40))
    rate2Star.layer.cornerRadius = 10.0
    rate2Star.layer.position = CGPoint(x: self.view.bounds.width/2 - 50, y:self.view.bounds.height/4 + 200)
    rate2Star.addTarget(self, action: "onClickRate2Star:", forControlEvents: .TouchUpInside)
    self.view.addSubview(rate2Star)

    // Rate 3 Star
    //let rate3Star = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    rate3Star.setTitleColor(secondaryText, forState: .Normal)
    rate3Star.layer.masksToBounds = true
    rate3Star.setTitle("★", forState: .Normal)
    rate3Star.titleLabel!.font = UIFont.systemFontOfSize(CGFloat(40))
    rate3Star.layer.cornerRadius = 10.0
    rate3Star.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/4 + 200)
    rate3Star.addTarget(self, action: "onClickRate3Star:", forControlEvents: .TouchUpInside)
    self.view.addSubview(rate3Star)

    // Rate 4 Star
    //let rate4Star = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    rate4Star.setTitleColor(secondaryText, forState: .Normal)
    rate4Star.layer.masksToBounds = true
    rate4Star.setTitle("★", forState: .Normal)
    rate4Star.titleLabel!.font = UIFont.systemFontOfSize(CGFloat(40))
    rate4Star.layer.cornerRadius = 10.0
    rate4Star.layer.position = CGPoint(x: self.view.bounds.width/2 + 50, y:self.view.bounds.height/4 + 200)
    rate4Star.addTarget(self, action: "onClickRate4Star:", forControlEvents: .TouchUpInside)
    self.view.addSubview(rate4Star)

    // Rate 5 Star
    //let rate5Star = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    rate5Star.setTitleColor(secondaryText, forState: .Normal)
    rate5Star.layer.masksToBounds = true
    rate5Star.setTitle("★", forState: .Normal)
    rate5Star.titleLabel!.font = UIFont.systemFontOfSize(CGFloat(40))
    rate5Star.layer.cornerRadius = 10.0
    rate5Star.layer.position = CGPoint(x: self.view.bounds.width/2 + 100, y:self.view.bounds.height/4 + 200)
    rate5Star.addTarget(self, action: "onClickRate5Star:", forControlEvents: .TouchUpInside)
    self.view.addSubview(rate5Star)
    
  }
  
  // ボタンイベントのセット.
  func onClickRate1Star(sender: UIButton){
    println("onClickRate1Star")
    rate1Star.setTitleColor(accentColor, forState: .Normal)
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userRes:JSON = self.getUser(JSON(self.getRequestStatus(appDelegate._requestStatusID!)["teacher"]).toString(pretty: true))
    var userRateRes = self.updateUserRate(JSON(userRes["userid"]).toString(pretty: true), rate: "1")
  }
  
  func onClickRate2Star(sender: UIButton){
    println("onClickRate2Star")
    rate1Star.setTitleColor(accentColor, forState: .Normal)
    rate2Star.setTitleColor(accentColor, forState: .Normal)
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userRes:JSON = self.getUser(JSON(self.getRequestStatus(appDelegate._requestStatusID!)["teacher"]).toString(pretty: true))
    var userRateRes = self.updateUserRate(JSON(userRes["userid"]).toString(pretty: true), rate: "2")
  }
  
  func onClickRate3Star(sender: UIButton){
    println("onClickRate3Star")
    rate1Star.setTitleColor(accentColor, forState: .Normal)
    rate2Star.setTitleColor(accentColor, forState: .Normal)
    rate3Star.setTitleColor(accentColor, forState: .Normal)
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userRes:JSON = self.getUser(JSON(self.getRequestStatus(appDelegate._requestStatusID!)["teacher"]).toString(pretty: true))
    var userRateRes = self.updateUserRate(JSON(userRes["userid"]).toString(pretty: true), rate: "3")
  }
  
  func onClickRate4Star(sender: UIButton){
    println("onClickRate4Star")
    rate1Star.setTitleColor(accentColor, forState: .Normal)
    rate2Star.setTitleColor(accentColor, forState: .Normal)
    rate3Star.setTitleColor(accentColor, forState: .Normal)
    rate4Star.setTitleColor(accentColor, forState: .Normal)
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userRes:JSON = self.getUser(JSON(self.getRequestStatus(appDelegate._requestStatusID!)["teacher"]).toString(pretty: true))
    var userRateRes = self.updateUserRate(JSON(userRes["userid"]).toString(pretty: true), rate: "4")
  }
  
  func onClickRate5Star(sender: UIButton){
    println("onClickRate5Star")
    rate1Star.setTitleColor(accentColor, forState: .Normal)
    rate2Star.setTitleColor(accentColor, forState: .Normal)
    rate3Star.setTitleColor(accentColor, forState: .Normal)
    rate4Star.setTitleColor(accentColor, forState: .Normal)
    rate5Star.setTitleColor(accentColor, forState: .Normal)
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var userRes:JSON = self.getUser(JSON(self.getRequestStatus(appDelegate._requestStatusID!)["teacher"]).toString(pretty: true))
    var userRateRes = self.updateUserRate(JSON(userRes["userid"]).toString(pretty: true), rate: "5")
  }
  

  func updateUserRate(userid:String,rate:String) -> JSON{
    var updateUserRateURL = "http://52.8.212.125/updateUserRate?userid=" + userid + "&rate=" + rate
    let updateUserRateRes = JSON(url: updateUserRateURL)
    println(updateUserRateURL)
    println(updateUserRateRes)
    return updateUserRateRes
  }
  
  func getRequestStatus(requestStatusID:String) -> JSON{
    var getRequestStatusURL = "http://52.8.212.125/getRequestStatus?_id=" + requestStatusID
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
  
  func getImage(image:String)->NSData{
    let url = NSURL(string: "http://52.8.212.125/getImage?url=" + image);
    var err: NSError?;
    var getImageRes :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!;
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
