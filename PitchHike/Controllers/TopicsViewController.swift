//
//  TopicsViewController.swift
//  PitchHike
//
//  Created by NinjaSE3 on 2015/07/24.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//

import UIKit
class TopicsViewController: UIViewController,UITableViewDelegate , UITableViewDataSource {
  
  //時間表示用のラベル.
  var timeLabel : UILabel!
  
  // Tableで使用する配列を設定する
  private var topicItems: [String] = [];
  private var myTableView: UITableView!

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
    
    self.view.backgroundColor = UIColor.whiteColor()
    self.createTimerView()
    self.createBackView()
    self.createTopicView()
  }
  
  func createTopicView(){
    // Topics取得
    var topics:JSON = self.getTopics()
    for(var i=0;i<20;i++){
      topicItems.append(topics[i]["topic"].toString(true))
      print(topics[i]["topic"].toString(true))
    }
    // Status Barの高さを取得する.
    let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
    // Viewの高さと幅を取得する.
    let displayWidth: CGFloat = self.view.frame.width
    let displayHeight: CGFloat = self.view.frame.height/1.15
    let displayHeightStart: CGFloat = self.view.frame.height/6
    // TableViewの生成する(status barの高さ分ずらして表示).
    myTableView = UITableView(frame: CGRect(x: 0, y: displayHeightStart, width: displayWidth, height: displayHeight - barHeight))
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
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    var requestStatus:JSON = self.getRequestStatus(appDelegate._requestStatusID)
    var requestStatus:JSON = self.getRequestStatus("559b6ac9e8deb3a44e12fc93")
    
    //ラベルを作る.
    var limtime = 15
    timeLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.width,40))
    timeLabel.backgroundColor = primaryColor
    timeLabel.textColor = textIcons
    timeLabel.layer.masksToBounds = true
    if(JSON(requestStatus["arrive"]).toString(true) != ""){
      timeLabel.text = "Time:"+JSON(requestStatus["arrive"]).toString(true)
    }
    timeLabel.textAlignment = NSTextAlignment.Center
    timeLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 50)
    self.view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(timeLabel)

  }
  
  func createBackView(){
    // ボタンの生成.
    let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width,height: 40))
    myButton.backgroundColor = lightPrimaryColor
    myButton.setTitleColor(primaryText, forState: .Normal)
    myButton.layer.masksToBounds = true
    myButton.setTitle("< Back            Today's Topics                        ", forState: .Normal)
    myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:90)
    myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
    self.view.addSubview(myButton)
  }
  
  // ボタンイベントのセット.
  func onClickMyButton(sender: UIButton){
    //戻り処理
  }
  
  
  func getRequestStatus(requestStatusID:String) -> JSON{
    let getRequestStatusURL = "http://localhost:8080/getRequestStatus?_id=" + requestStatusID
    let requestStatus = JSON(url: getRequestStatusURL)
    print(getRequestStatusURL)
    print(requestStatus)
    return requestStatus
  }
  
  /*
  Cellが選択された際に呼び出されるデリゲートメソッド.
  */
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    print("Num: \(indexPath.row)")
    print("Value: \(topicItems[indexPath.row])")
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
    let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) 
    
    // Cellに値を設定する.
    cell.textLabel!.text = "\(topicItems[indexPath.row])"
    cell.backgroundColor = textIcons
    return cell
  }
  
  
  func getTopics() -> JSON{
    let getTopicsURL = "http://localhost:8080/getTopics"
    let topicsRes = JSON(url: getTopicsURL)
    print(getTopicsURL)
    print(topicsRes)
    return topicsRes
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
}
