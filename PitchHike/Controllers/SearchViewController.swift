//
//  SearchViewController.swift
//  PitchHike
//
//  Created by NinjaSE3 on 2015/06/30.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController,CLLocationManagerDelegate {
  
  var myLocationManager:CLLocationManager!
  
  struct location{
    static var lat = ""
    static var lng = ""
  }
  
  struct error{
    static var err = ""
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.createView()
    self.createButton()
  }
  
  func createView(){
    self.view.backgroundColor = UIColor.whiteColor()
  }
  
  func createButton(){
    // ボタンの生成.
    let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    myButton.backgroundColor = UIColor.orangeColor()
    myButton.layer.masksToBounds = true
    myButton.setTitle("Search", forState: .Normal)
    myButton.layer.cornerRadius = 50.0
    myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2)
    myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
    self.view.addSubview(myButton)
  }
  
  
  // ボタンイベントのセット.
  func onClickMyButton(sender: UIButton){
    // Geo Request
    self.getGeo()
  }
  
  
  func getGeo(){
    // 現在地の取得.
    myLocationManager = CLLocationManager()
    
    myLocationManager.delegate = self
    // セキュリティ認証のステータスを取得.
    let status = CLLocationManager.authorizationStatus()
    // まだ認証が得られていない場合は、認証ダイアログを表示.
    if(status == CLAuthorizationStatus.NotDetermined) {
      print("didChangeAuthorizationStatus:\(status)");
      // まだ承認が得られていない場合は、認証ダイアログを表示.
      self.myLocationManager.requestAlwaysAuthorization()
    }
    // 取得精度の設定.
    myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
    // 取得頻度の設定.
    myLocationManager.distanceFilter = 100
    
    // 現在位置の取得を開始.
    myLocationManager.startUpdatingLocation()
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    
    print("didChangeAuthorizationStatus");
    
    // 認証のステータスをログで表示.
    var statusStr = "";
    switch (status) {
    case .NotDetermined:
      statusStr = "NotDetermined"
    case .Restricted:
      statusStr = "Restricted"
    case .Denied:
      statusStr = "Denied"
    case .AuthorizedAlways:
      statusStr = "AuthorizedAlways"
    case .AuthorizedWhenInUse:
      statusStr = "AuthorizedWhenInUse"
    }
    print(" CLAuthorizationStatus: \(statusStr)")
  }
  
  // 位置情報取得に成功したときに呼び出されるデリゲート.
  func locationManager(manager: CLLocationManager,didUpdateLocations locations: [CLLocation]){
    
    location.lat = String(stringInterpolationSegment: manager.location!.coordinate.latitude)
    location.lng = String(stringInterpolationSegment: manager.location!.coordinate.longitude)
    
    print(location.lat)
    print(location.lng)
    
    //req:lat,lng,language,userid res:requestStatus
    let requestTeacherRes = self.requestTeacher(location.lat, lng: location.lng, lang: "English", userid: "000001")
    print(requestTeacherRes["status"])
    
    // 現在日時を取得
    var date1 = NSDate()
    while(true){
      let requestStatusRes = self.getRequestStatus(requestTeacherRes["_id"].toString(true))
      print(requestStatusRes["status"])
      
      sleep(1)
      // 現在日時を取得
      var date2 = NSDate()
      var time  = Float(date2.timeIntervalSinceDate(date1))
      print(time)
      
      var status:String = requestStatusRes["status"].toString(true)
      if( requestStatusRes["status"].toString(true) == "res" ){
        break
      }
      if(time > Float(5)){
        error.err = "TimeOut"
        break
      }
    }
    
    if(error.err != "TimeOut"){
      //AppDelegateのインスタンスを取得
      var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      //appDelegateの変数を操作
      appDelegate._requestStatusID = requestTeacherRes["_id"].toString(true)
      // 遷移するViewを定義する.
      let matchingViewController: UIViewController = MatchingViewController()
      // アニメーションを設定する.
      matchingViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
      // Viewの移動する.
      self.presentViewController(matchingViewController, animated: true, completion: nil)
    }else{
      print("Search失敗", terminator: "")
    }
  }
  
  // 位置情報取得に失敗した時に呼び出されるデリゲート.
  func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
    print("error", terminator: "")
  }
  
  func requestTeacher(lat:String,lng:String,lang:String,userid:String) -> JSON{
    let requestTeacherURL = "http://52.8.212.125/requestTeacher?lat=" + String(lat) + "&lng="+String(lng)+"&lang=" + String(lang) + "&userid=" + String(userid)
    let requestTeacherRes = JSON(url: requestTeacherURL)
    print(requestTeacherURL)
    print(requestTeacherRes)
    return requestTeacherRes
  }
  
  func getRequestStatus(_id:String) -> JSON{
    let getRequestStatusURL = "http://52.8.212.125/getRequestStatus?_id="+_id
    let requestStatusRes = JSON(url: getRequestStatusURL)
    print(getRequestStatusURL)
    print(requestStatusRes)
    return requestStatusRes
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  
  
}

