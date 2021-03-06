//
//  MapViewController.swift
//  PitchHike
//
//  Created by NinjaSE3 on 2015/06/30.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, TypesTableViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
  
  private var teacherImageView: UIImageView!
  
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var mapCenterPinImage: UIImageView!
  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
  
  var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
  
  let locationManager = CLLocationManager()
  let dataProvider = GoogleDataProvider()
  
  var totalDistance: String!
  var totalDuration: String!
  
  // 配色
  private var secondaryText:UIColor!
  private var primaryText:UIColor!
  private var accentColor:UIColor!
  private var darkPrimaryColor:UIColor!
  private var primaryColor:UIColor!
  private var lightPrimaryColor:UIColor!
  private var textIcons:UIColor!
  private var dividerColor:UIColor!
  
  var randomLineColor: UIColor {
    get {
      let randomRed = CGFloat(drand48())
      let randomGreen = CGFloat(drand48())
      let randomBlue = CGFloat(drand48())
      return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
  }
  
  var mapRadius: Double {
    get {
      let region = mapView.projection.visibleRegion()
      let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
      let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
      return max(horizontalDistance, verticalDistance)*0.5
    }
  }

  func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
    NSLog("---MapViewController fetchNearbyPlaces---");
    // 1
    mapView.clear()
    NSLog("---MapViewController mapView.clear()---");
    
    // 2
    dataProvider.fetchPlacesNearCoordinate(coordinate, radius:mapRadius, types: searchedTypes) { places in
      for place: GooglePlace in places {
        NSLog("---MapViewController for place: GooglePlace in places---");
        // 3
        let marker = PlaceMarker(place: place)
        NSLog("---MapViewController PlaceMarker---");
        // 4
        marker.map = self.mapView
        NSLog("---MapViewController self.mapView---");
      }
    }
  }
  
  @IBAction func refreshPlaces(sender: AnyObject) {
    NSLog("---MapViewController refreshPlaces---");
    fetchNearbyPlaces(mapView.camera.target)
  }
  
  @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
    NSLog("---MapViewController mapTypeSegmentPressed---");
    let segmentedControl = sender as! UISegmentedControl
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      mapView.mapType = kGMSTypeNormal
    case 1:
      mapView.mapType = kGMSTypeSatellite
    case 2:
      mapView.mapType = kGMSTypeHybrid
    default:
      mapView.mapType = mapView.mapType
    }
  }
  
  func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
    NSLog("---MapViewController mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!)---");
    // 1
    let placeMarker = marker as! PlaceMarker
    
    // 2
    if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
      // 3
      infoView.nameLabel.text = placeMarker.place.name
      infoView.backgroundColor = textIcons

      // 4
      if let photo = placeMarker.place.photo {
        infoView.placePhoto.image = photo
      } else {
        infoView.placePhoto.image = UIImage(named: "generic")
      }
      
      return infoView
    } else {
      return nil
    }
  }
  
  // 1
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    NSLog("---MapViewController locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)---");
    // 2
    if status == .AuthorizedWhenInUse {
      NSLog("---MapViewController AuthorizedWhenInUse---");
      
      // 3
      locationManager.startUpdatingLocation()
      NSLog("---MapViewController startUpdatingLocation---");
      
      //4
      mapView.myLocationEnabled = true
      mapView.settings.myLocationButton = true
      NSLog("---MapViewController myLocationEnabled & myLocationButton---");
      
    }
  }
  
  func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
    NSLog("---MapViewController mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!)---");
    mapCenterPinImage.fadeOut(0.25)
    return false
  }
  
  // 5 位置情報取得成功後のdelgate
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    NSLog("---MapViewController locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])---");
    NSLog((locations.first?.description)!);
    if let location = locations.first as? CLLocation! {
      NSLog("---MapViewController locations.first true---");
      // 6
      mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      
      // 7
      locationManager.stopUpdatingLocation()
      fetchNearbyPlaces(location.coordinate)
    }
  }
  
  func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
    NSLog("---MapViewController reverseGeocodeCoordinate---");
    let geocoder = GMSGeocoder()
    geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
      
      //Add this line
      self.addressLabel.unlock()
      if let address = response?.firstResult() {
        NSLog("---MapViewController address = response?.firstResult()---");
        self.addressLabel.backgroundColor = self.primaryColor
        self.addressLabel.textColor = self.lightPrimaryColor
        let lines = address.lines as! [String]
        self.addressLabel.text = lines.joinWithSeparator("\n")
        
        let labelHeight = self.addressLabel.intrinsicContentSize().height
        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
        UIView.animateWithDuration(0.25) {
          NSLog("---MapViewController UIView.animateWithDuration(0.25)---");
          self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
  func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
    NSLog("---MapViewController mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!)---");
    // 1
    let googleMarker = mapView.selectedMarker as! PlaceMarker
    
    // 2
    dataProvider.fetchDirectionsFrom(mapView.myLocation.coordinate, to: googleMarker.place.coordinate) {optionalRoute in
      if let encodedRoute = optionalRoute {
        // 3
        let path = GMSPath(fromEncodedPath: encodedRoute)
        let line = GMSPolyline(path: path)
        
        
        // 4
        line.strokeWidth = 4.0
        line.tappable = true
        line.map = self.mapView
        line.strokeColor = self.randomLineColor
        
        // 5
        mapView.selectedMarker = nil
        
        // 6
        //AppDelegateのインスタンスを取得
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if(appDelegate._screen == "Matching"){
          
//        //マッチした先生の情報取得
//        let usrTmp = appDelegate._userId
//        let usrId = self.getUser(usrTmp!)
//        println(usrId)
//          
//        //マッチした先生の情報表示
//        self.addressLabel.unlock()
//        
//        let lines = usrId["name"].toString(pretty: true)
//        self.addressLabel.text = "\(lines)"
//        
//        let labelHeight = self.addressLabel.intrinsicContentSize().height
//        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
          
        //
        var requestStatus = appDelegate._requestStatusID
          //    var requestStatus = "559b673c6a97fd654ea0955f"
          print(requestStatus)
          
        var teacher:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus!)["teacher"]).toString(true))
          
          let teacherBackgroundView = UIButton(frame: CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height/4.5))
          teacherBackgroundView.backgroundColor = self.textIcons
          teacherBackgroundView.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height - self.view.bounds.height/5.8)
          teacherBackgroundView.tag = 9999
          self.view.addSubview(teacherBackgroundView)
          
          // TeacherPhoto
          // UIImageViewを作成する.
          let teacherImageView = UIImageView(frame: CGRectMake(0,0,100,100))
          teacherImageView.tag = 9999;
          // 表示する画像を設定する.
          let teacherImage = UIImage(data: self.getImage(JSON(teacher["image"]).toString(true)))
          // 画像をUIImageViewに設定する.
          teacherImageView.image = teacherImage
          // 画像の表示する座標を指定する.
          teacherImageView.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height - self.view.bounds.height/3.6)
          // ジェスチャーを追加
          let gesture = UITapGestureRecognizer(target:self, action:"onClickTeacherImageView:")
          teacherImageView.userInteractionEnabled = true
          teacherImageView.addGestureRecognizer(gesture)
          // UIImageViewをViewに追加する.
          self.view.addSubview(teacherImageView)
          
          // Teacher Name
          let teacherPhoto = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
          teacherPhoto.tag = 9999
          //teacherPhoto.backgroundColor = UIColor.redColor()
          teacherPhoto.setTitleColor(self.primaryText, forState: .Normal)
          teacherPhoto.layer.masksToBounds = true
          teacherPhoto.setTitle(JSON(teacher["name"]).toString(true), forState: .Normal)
          teacherPhoto.layer.cornerRadius = 10.0
          teacherPhoto.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height - self.view.bounds.height/5.6)
          self.view.addSubview(teacherPhoto)
          
          // Topic表示用
          self.createTopicButton()
          
          
          // 到着時間表示用
          //var arvTime:JSON = self.getArrivedTime(JSON(requestStatus))
          
          // 到着時間表示
//          let arvTimeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
//          arvTimeButton.backgroundColor = UIColor.redColor()
//          arvTimeButton.layer.masksToBounds = true
//          arvTimeButton.setTitle(JSON(arvTime["arrive"]).toString(pretty: true), forState: .Normal)
//          arvTimeButton.layer.cornerRadius = 10.0
//          arvTimeButton.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3, y:self.view.bounds.height/1.4)
//          self.view.addSubview(teacherPhoto)
          
          
          //TODO 先生の位置情報取得して、画像表示
//          println(teacher)
//          println(teacher["location"][0])
//          println(teacher["location"][1])
//          
//          let place: GooglePlace
//          let coordinate: CLLocationCoordinate2D
//          
//          let lat = (JSON(teacher["location"][0]).toString(pretty: true) as! NSString).doubleValue as! CLLocationDegrees
//          let lng = (JSON(teacher["location"][1]).toString(pretty: true) as! NSString).doubleValue as! CLLocationDegrees
//          
//          coordinate = CLLocationCoordinate2DMake(lat, lng)
//          
////          place.coordinate = coordinate
//          let marker = GMSMarker(position: coordinate)
//          marker.title = "test"
//          marker.map = self.mapView
          
//          UIView.animateWithDuration(0.25) {
//            self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
//            self.view.layoutIfNeeded()
//          }
        }
      }
    }
    
  }
  
  func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
    NSLog("---MapViewController mapView(mapView: GMSMapView!, willMove gesture: Bool)---");
    addressLabel.lock()
    if (gesture) {
      mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
      
      let views = self.view.subviews
      for myView in views {
        print("View:\(myView.description)")
        
        if myView.tag == 9999 {
          continue
        }
        if myView.isKindOfClass(UIButton) {
          myView.removeFromSuperview()
        }
//        if myView.isEqual() {
//          myView.removeFromSuperview()
//        }
      }
    }
  }
  
  func didTapMyLocationButtonForMapView(mapView: GMSMapView!) -> Bool {
    NSLog("---MapViewController didTapMyLocationButtonForMapView---");
    mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
    return false
  }
  
  func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
    NSLog("---MapViewController mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!)---");
    reverseGeocodeCoordinate(position.target)
  }
  
  override func viewDidLoad() {
    NSLog("---MapViewController viewDidLoad---");
    super.viewDidLoad()
    
    secondaryText = UIColorFromRGB(0x727272);
    primaryText = UIColorFromRGB(0x212121);
    accentColor = UIColorFromRGB(0xFF4081);
    darkPrimaryColor = UIColorFromRGB(0x0288D1);
    primaryColor = UIColorFromRGB(0x03A9F4);
    lightPrimaryColor = UIColorFromRGB(0xB3E5FC);
    textIcons = UIColorFromRGB(0xF8F8F8);
    dividerColor = UIColorFromRGB(0xB6B6B6);
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()

    //利用者の顔
    let appuserimgView = UIImageView(frame: CGRectMake(0,0,75,75))
    var appuser:JSON = self.getUser("000001")
    let appuserimg = UIImage(data: self.getImage(JSON(appuser["image"]).toString(true)))
    appuserimgView.image = appuserimg
    appuserimgView.layer.position = CGPoint(x: 50, y: 110)
    self.view.addSubview(appuserimgView)
    
    mapView.delegate = self
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    NSLog("---MapViewController prepareForSegue---");
    if segue.identifier == "Types Segue" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = (segue.destinationViewController as! UINavigationController).topViewController as!TypesTableViewController
      controller.selectedTypes = searchedTypes
      controller.delegate = self
    }
  }
  
  // MARK: - Types Controller Delegate
  func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
    NSLog("---MapViewController typesController---");
    searchedTypes = controller.selectedTypes.sort()
    dismissViewControllerAnimated(true, completion: nil)
    fetchNearbyPlaces(mapView.camera.target)
  }
  
  func getRequestStatus(_id:String) -> JSON{
    NSLog("---MapViewController getRequestStatus---");
    let getRequestStatusURL = "http://localhost:8080/getRequestStatus?_id="+_id
    let requestStatusRes = JSON(url: getRequestStatusURL)
    print(getRequestStatusURL)
    print(requestStatusRes)
    return requestStatusRes
  }
  
  func getUser(requestUserId:String) -> JSON{
    NSLog("---MapViewController getUser---");
    let userReq = "http://localhost:8080/getUser?userid=" + requestUserId
    let user = JSON(url: userReq)
    print(userReq)
    print(user)
    return user
  }
  
  func createTopicButton(){
    NSLog("---MapViewController createTopicButton---");
    // トピック表示ボタンの生成.
    let myButton = ZFRippleButton(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    myButton.tag = 9999
    myButton.backgroundColor = accentColor
    myButton.setTitleColor(textIcons, forState: .Normal)
    myButton.layer.masksToBounds = true
    myButton.setTitle("Get arrived!", forState: .Normal)
    myButton.layer.cornerRadius = 5.0
    myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height - self.view.bounds.height/8.3)
    myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
    self.view.addSubview(myButton)
    
  }
  //UIntに16進で数値をいれるとUIColorが戻る関数
  func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    NSLog("---MapViewController UIColorFromRGB---");
    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  // トピック表示ボタンイベントのセット.
  func onClickMyButton(sender: UIButton){
    NSLog("---MapViewController onClickMyButton---");
    
    //プレゼン用の偽装コード　使い終わったら必ず消すこと！！
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var teacheruser:JSON = self.getRequestStatus(appDelegate._requestStatusID!)
    var teacherJSON:JSON = self.getUser(JSON(teacheruser["teacher"]).toString(true))
    self.responseTeacher(JSON(teacherJSON["userid"]).toString(true) ,requestStatusID: appDelegate._requestStatusID!)
    //プレゼン用の偽装コード　使い終わったら必ず消すこと！！

    // 遷移するViewを定義する.
    let startViewController: UIViewController = StartViewController()
    // アニメーションを設定する.
    startViewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    // Viewの移動する.
    self.presentViewController(startViewController, animated: true, completion: nil)
  }
  
  // 先生の写真クリック時にプロフィール画面を表示する
  func onClickTeacherImageView(recognizer: UIGestureRecognizer) {
    NSLog("---MapViewController onClickTeacherImageView---");
    let profileViewController: UIViewController = ProfileViewController()
    navigationController?.pushViewController(profileViewController, animated: true)
  }
  
  func getImage(image:String)->NSData{
    NSLog("---MapViewController getImage---");
    let url = NSURL(string: "http://localhost:8080/getImage?url=" + image);
    var err: NSError?;
    let getImageRes :NSData = try! NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe);
    return getImageRes
  }

  
  //プレゼン用の偽装コード　使い終わったら必ず消すこと！！
  func responseTeacher(userid:String,requestStatusID:String) -> JSON{
    NSLog("---MapViewController responseTeacher---");
    let responseTeacherURL = "http://localhost:8080/responseTeacher?userid=" + userid + "&_id=" + requestStatusID
    let responseTeacherRes = JSON(url: responseTeacherURL)
    print(responseTeacherURL)
    print(responseTeacherRes)
    return responseTeacherRes
  }
  //プレゼン用の偽装コード　使い終わったら必ず消すこと！！

  
  func getArrivedTime(_id:String) -> JSON{
    NSLog("---MapViewController getArrivedTime---");
    let getArrivedTimeURL = "http://localhost:8080/updateArrive?_id="+_id
    let requestStatusRes = JSON(url: getArrivedTimeURL)
    print(getArrivedTimeURL)
    print(requestStatusRes)
    return requestStatusRes
  }
  
}

