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

  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.whiteColor()
    self.createTimerView()
    self.createBackView()
    self.createTopicView()
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
    timeLabel.backgroundColor = UIColor.blackColor()
    timeLabel.layer.masksToBounds = true
    if(JSON(requestStatus["arrive"]).toString(pretty: true) != ""){
      timeLabel.text = "Time:"+JSON(requestStatus["arrive"]).toString(pretty: true)
    }
    timeLabel.textColor = UIColor.whiteColor()
    timeLabel.textAlignment = NSTextAlignment.Center
    timeLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 50)
    self.view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(timeLabel)

  }
  
  func createBackView(){
    // ボタンの生成.
    let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width,height: 40))
    myButton.backgroundColor = UIColor.grayColor()
    myButton.layer.masksToBounds = true
    myButton.setTitle("Back", forState: .Normal)
    myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:90)
    myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
    self.view.addSubview(myButton)
  }
  
  // ボタンイベントのセット.
  func onClickMyButton(sender: UIButton){
    //戻り処理
  }
  
  
  func getRequestStatus(requestStatusID:String) -> JSON{
    var getRequestStatusURL = "http://52.8.212.125/getRequestStatus?_id=" + requestStatusID
    let requestStatus = JSON(url: getRequestStatusURL)
    println(getRequestStatusURL)
    println(requestStatus)
    return requestStatus
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
    cell.backgroundColor = UIColor.cyanColor()
    return cell
  }
  
  
  func getTopics() -> JSON{
    var getTopicsURL = "http://52.8.212.125/getTopics"
    let topicsRes = JSON(url: getTopicsURL)
    println(getTopicsURL)
    println(topicsRes)
    return topicsRes
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
