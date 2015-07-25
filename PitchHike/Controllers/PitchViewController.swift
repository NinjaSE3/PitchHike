//
//  PitchViewController.swift
//  PitchHike
//
//  Created by NinjaSE3 on 2015/07/22.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//


import UIKit
class PitchViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource {
  
  //時間計測用の変数.
  var limtime : Float = 30
  
  //時間表示用のラベル.
  var myLabel : UILabel!
  
  // Tableで使用する配列を設定する
  private var topicItems: [String] = [];
  private var myTableView: UITableView!
  
  private var studentImageView: UIImageView!
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
    
    self.createTimerView()
    self.createStartButton()
    self.createMatchingView()
    self.createTopicView()
    self.start()
    
  }
  
  func createTopicView(){
    // Topics取得
    var topics:JSON = self.getTopics()
    for(var i=0;i<20;i++){
      topicItems.append(topics[i]["topic"].toString(pretty: true))
      println(topics[i]["topic"].toString(pretty: true))
    }
    // Status Barの高さを取得する.
    let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
    // Viewの高さと幅を取得する.
    let displayWidth: CGFloat = self.view.frame.width
    let displayHeight: CGFloat = self.view.frame.height/2
    // TableViewの生成する(status barの高さ分ずらして表示).
    myTableView = UITableView(frame: CGRect(x:0 , y: displayHeight, width: displayWidth, height: displayHeight - barHeight + 20))
    // Cell名の登録をおこなう.
    myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
    // DataSourceの設定をする.
    myTableView.dataSource = self
    // Delegateを設定する.
    myTableView.delegate = self
    // Viewに追加する.
    self.view.addSubview(myTableView)
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
    myButton.setTitle("END", forState: .Normal)
    myButton.layer.cornerRadius = 5.0
    myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2.4)
    myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
    self.view.addSubview(myButton)
  }
  
  
  // ボタンイベントのセット.
  func onClickMyButton(sender: UIButton){
    //Pitchを終了する
    self.finishPitch()
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
    }else if(limtime == -1){
      //Pitchを終了する
      self.finishPitch()
    }
    
  }
  
  func finishPitch(){
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var finishPitching:JSON = self.finishPitching(appDelegate._requestStatusID!)
//    var finishPitching:JSON = self.finishPitching("559b673c6a97fd654ea0955f")
    
    if(finishPitching["status"].toString(pretty: true) == "finish"){
      // 遷移するViewを定義する.
      let rateViewController: UIViewController = RateViewController()
      // アニメーションを設定する.
      rateViewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
      // Viewの移動する.
      self.presentViewController(rateViewController, animated: true, completion: nil)
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
    studentImageView.layer.position = CGPoint(x: self.view.bounds.width/3.2, y: self.view.bounds.height/4.2)
    // UIImageViewをViewに追加する.
    self.view.addSubview(studentImageView)
    
    
    // StudentName
    let studentName = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    //studentName.backgroundColor = textIcons
    studentName.setTitleColor(primaryText, forState: .Normal)
    studentName.layer.masksToBounds = true
    studentName.setTitle(JSON(student["name"]).toString(pretty: true), forState: .Normal)
    studentName.layer.cornerRadius = 10.0
    studentName.layer.position = CGPoint(x: self.view.bounds.width/3.2, y:self.view.bounds.height/3)
    self.view.addSubview(studentName)
    
    // TeacherPhoto
    // UIImageViewを作成する.
    teacherImageView = UIImageView(frame: CGRectMake(0,0,100,100))
    // 表示する画像を設定する.
    let teacherImage = UIImage(data: self.getImage(JSON(teacher["image"]).toString(pretty: true)))
    // 画像をUIImageViewに設定する.
    teacherImageView.image = teacherImage
    // 画像の表示する座標を指定する.
    teacherImageView.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3.2, y: self.view.bounds.height/4.2)
    // UIImageViewをViewに追加する.
    self.view.addSubview(teacherImageView)
    
    // TeacherName
    let teacherName = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    //teacherName.backgroundColor = textIcons
    teacherName.setTitleColor(primaryText, forState: .Normal)
    teacherName.layer.masksToBounds = true
    teacherName.setTitle(JSON(teacher["name"]).toString(pretty: true), forState: .Normal)
    teacherName.layer.cornerRadius = 10.0
    teacherName.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3.2, y:self.view.bounds.height/3)
    self.view.addSubview(teacherName)
  }
  
  /*
  Cellが選択された際に呼び出されるデリゲートメソッド.
  */
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("Num: \(indexPath.row)")
    println("Value: \(topicItems[indexPath.row])")
  }
  
  /*
  Cellの総数を返すデータソースメソッド.
  (実装必須)
  */
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return topicItems.count
  }
  
  /*
  Cellに値を設定するデータソースメソッド.
  (実装必須)
  */
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    // 再利用するCellを取得する.
    let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! UITableViewCell
    
    // Cellに値を設定する.
    cell.textLabel!.text = "\(topicItems[indexPath.row])"
    // Cellにデザインを適用する
    cell.textLabel?.textColor = secondaryText
    cell.backgroundColor = textIcons
    
    return cell
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
  
  func getTopics() -> JSON{
    var getTopicsURL = "http://52.8.212.125/getTopics"
    let topicsRes = JSON(url: getTopicsURL)
    println(getTopicsURL)
    println(topicsRes)
    return topicsRes
  }
  
  func finishPitching(requestStatusID:String) -> JSON{
    var finishPitchingURL = "http://52.8.212.125/finishPitching?_id=" + requestStatusID
    let finishPitchingRes = JSON(url: finishPitchingURL)
    println(finishPitchingURL)
    println(finishPitchingRes)
    return finishPitchingRes
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