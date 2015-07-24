//
//  StartViewController.swift
//  PitchHike
//
//  Created by Takaaki on 2015/07/22.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//


import UIKit
class StartViewController: UIViewController ,UITableViewDelegate , UITableViewDataSource {
  
  //時間計測用の変数.
  var limtime : Float = 30
  
  //時間表示用のラベル.
  var myLabel : UILabel!
  
  // Tableで使用する配列を設定する
  private var topicItems: [String] = [];
  private var myTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.createTimerView()
    self.createStartButton()
    self.createMatchingView()
    self.createTopicView()
    
  }
  
  func createTopicView(){
    // Topics取得
    var topics:JSON = self.getTopics()
    
    for(var i=0;i<10;i++){
      topicItems.append(topics[i]["topic"].toString(pretty: true))
      println(topics[i]["topic"].toString(pretty: true))
    }
    
    // Status Barの高さを取得する.
    let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
    
    // Viewの高さと幅を取得する.
    let displayWidth: CGFloat = self.view.frame.width
    let displayHeight: CGFloat = self.view.frame.height/2
    
    // TableViewの生成する(status barの高さ分ずらして表示).
    myTableView = UITableView(frame: CGRect(x:0 , y: displayHeight, width: displayWidth, height: displayHeight - barHeight))
    
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
    myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/3)
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
  
  
  func createMatchingView(){
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    var requestStatus = appDelegate._requestStatusID
    var requestStatus = "559b673c6a97fd654ea0955f"
    println(requestStatus)
    
    var student:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus)["student"]).toString(pretty: true))
    
    var teacher:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus)["teacher"]).toString(pretty: true))
    
    
    // StudentPhoto
    let studentPhoto = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    studentPhoto.backgroundColor = UIColor.blackColor()
    studentPhoto.layer.masksToBounds = true
    studentPhoto.setTitle(JSON(student["name"]).toString(pretty: true), forState: .Normal)
    studentPhoto.layer.cornerRadius = 50.0
    studentPhoto.layer.position = CGPoint(x: self.view.bounds.width/4, y:self.view.bounds.height/5)
    self.view.addSubview(studentPhoto)
    
    // TeacherPhoto
    let teacherPhoto = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    teacherPhoto.backgroundColor = UIColor.redColor()
    teacherPhoto.layer.masksToBounds = true
    teacherPhoto.setTitle(JSON(teacher["name"]).toString(pretty: true), forState: .Normal)
    teacherPhoto.layer.cornerRadius = 50.0
    teacherPhoto.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/4, y:self.view.bounds.height/5)
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
  
  func getTopics() -> JSON{
    var getTopicsURL = "http://52.8.212.125/getTopics"
    let topicsRes = JSON(url: getTopicsURL)
    println(getTopicsURL)
    println(topicsRes)
    return topicsRes
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
    
    return cell
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}