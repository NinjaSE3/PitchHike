//
//  MatchingViewController.swift
//  PitchHike
//
//  Created by NinjaSE3 on 2015/07/06.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//

import UIKit
import CoreLocation

class MatchingViewController: UIViewController,CLLocationManagerDelegate {
  var myLocationManager:CLLocationManager!
  
  // ベース画像.
  let myInputImage = CIImage(image: UIImage(named: "kyoto.jpg")!)
  
  // UIView
  var myImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.createBlur()
    self.createView()
    self.createMatchingView()
  }
  
  func createView(){
    self.view.backgroundColor = UIColor.whiteColor()
  }
  
  func createBlur(){
    // UIImageに変換.
    let myInputUIImage: UIImage = UIImage(CIImage: myInputImage!)
    
    // ImageView.
    myImageView = UIImageView(frame: CGRectMake(0, 0, myInputUIImage.size.width, myInputUIImage.size.height))
    
    // UIImageViewの生成.
    myImageView.image = myInputUIImage
    self.view.addSubview(myImageView)
    
    // CIFilterを生成。nameにどんなを処理するのか記入.
    var myBlurFilter = CIFilter(name: "CIGaussianBlur")
    
    // ばかし処理をいれたい画像をセット.
    myBlurFilter!.setValue(myInputImage, forKey: kCIInputImageKey)
    
    // フィルターを通した画像をアウトプット.
    let myOutputImage : CIImage = myBlurFilter!.outputImage!
    
    // UIImageに変換.
    let myOutputUIImage: UIImage = UIImage(CIImage: myOutputImage)
    
    // 再びUIViewにセット.
    myImageView.image = myOutputUIImage
    
    // 再描画.
    myImageView.setNeedsDisplay()
  }
  
  func createMatchingView(){
    //AppDelegateのインスタンスを取得
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var requestStatus = appDelegate._requestStatusID
    print(requestStatus)
    
    var student:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus!)["student"]).toString(true))
    
    var teacher:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus!)["teacher"]).toString(true))
    
    
    // StudentPhoto
    let studentPhoto = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    studentPhoto.backgroundColor = UIColor.blackColor()
    studentPhoto.layer.masksToBounds = true
    studentPhoto.setTitle(JSON(student["name"]).toString(true), forState: .Normal)
    studentPhoto.layer.cornerRadius = 50.0
    studentPhoto.layer.position = CGPoint(x: self.view.bounds.width/4, y:self.view.bounds.height/4)
    self.view.addSubview(studentPhoto)
    
    // TeacherPhoto
    let teacherPhoto = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    teacherPhoto.backgroundColor = UIColor.redColor()
    teacherPhoto.layer.masksToBounds = true
    teacherPhoto.setTitle(JSON(teacher["name"]).toString(true), forState: .Normal)
    teacherPhoto.layer.cornerRadius = 50.0
    teacherPhoto.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/4, y:self.view.bounds.height/4)
    self.view.addSubview(teacherPhoto)
    
  }
  
  func getRequestStatus(requestStatus:String) -> JSON{
    let getRequestStatusURL = "http://localhost:8080/getRequestStatus?_id=" + requestStatus
    let requestStatus = JSON(url: getRequestStatusURL)
    print(getRequestStatusURL)
    print(requestStatus)
    return requestStatus
  }
  
  func getUser(requestUserId:String) -> JSON{
    let getUserURL = "http://localhost:8080/getUser?userid=" + requestUserId
    let userRes = JSON(url: getUserURL)
    print(getUserURL)
    print(userRes)
    return userRes
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}