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
    // 1
    mapView.clear()
    
    // 2
    dataProvider.fetchPlacesNearCoordinate(coordinate, radius:mapRadius, types: searchedTypes) { places in
      for place: GooglePlace in places {
        // 3
        let marker = PlaceMarker(place: place)
        // 4
        marker.map = self.mapView
      }
    }
  }
  
  @IBAction func refreshPlaces(sender: AnyObject) {
    fetchNearbyPlaces(mapView.camera.target)
  }
  
  @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
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
    // 1
    let placeMarker = marker as! PlaceMarker
    
    // 2
    if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
      // 3
      infoView.nameLabel.text = placeMarker.place.name

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
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    // 2
    if status == .AuthorizedWhenInUse {
      
      // 3
      locationManager.startUpdatingLocation()
      
      //4
      mapView.myLocationEnabled = true
      mapView.settings.myLocationButton = true
    }
  }
  
  func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
    mapCenterPinImage.fadeOut(0.25)
    return false
  }
  
  // 5 位置情報取得成功後のdelgate
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    if let location = locations.first as? CLLocation {
      // 6
      mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 20, bearing: 0, viewingAngle: 0)
      
      // 7
      locationManager.stopUpdatingLocation()
      fetchNearbyPlaces(location.coordinate)
    }
  }
  
  func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
    let geocoder = GMSGeocoder()
    geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
      
      //Add this line
      self.addressLabel.unlock()
      if let address = response?.firstResult() {
        let lines = address.lines as! [String]
        self.addressLabel.text = join("\n", lines)
        
        let labelHeight = self.addressLabel.intrinsicContentSize().height
        self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
        UIView.animateWithDuration(0.25) {
          self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
          self.view.layoutIfNeeded()
        }
      }
    }
  }
  
  func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
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
          println(requestStatus)
          
        var teacher:JSON = self.getUser(JSON(self.getRequestStatus(requestStatus!)["teacher"]).toString(pretty: true))
          
          // TeacherPhoto
          // UIImageViewを作成する.
          let teacherImageView = UIImageView(frame: CGRectMake(0,0,100,100))
          // 表示する画像を設定する.
          let teacherImage = UIImage(data: self.getImage(JSON(teacher["image"]).toString(pretty: true)))
          // 画像をUIImageViewに設定する.
          teacherImageView.image = teacherImage
          // 画像の表示する座標を指定する.
          teacherImageView.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3, y: self.view.bounds.height/2)
          // UIImageViewをViewに追加する.
          self.view.addSubview(teacherImageView)
          
          // Teacher Name
          let teacherPhoto = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
          teacherPhoto.backgroundColor = UIColor.redColor()
          teacherPhoto.layer.masksToBounds = true
          teacherPhoto.setTitle(JSON(teacher["name"]).toString(pretty: true), forState: .Normal)
          teacherPhoto.layer.cornerRadius = 10.0
          teacherPhoto.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3, y:self.view.bounds.height/1.65)
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
    addressLabel.lock()
    if (gesture) {
      mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
      
      let views = self.view.subviews
      for (myView: UIView) in views as! [UIView] {
        println("View:\(myView.description)")
        
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
    mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
    return false
  }
  
  func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
    reverseGeocodeCoordinate(position.target)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    mapView.delegate = self
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Types Segue" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = segue.destinationViewController.topViewController as! TypesTableViewController
      controller.selectedTypes = searchedTypes
      controller.delegate = self
    }
  }
  
  // MARK: - Types Controller Delegate
  func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
    searchedTypes = sorted(controller.selectedTypes)
    dismissViewControllerAnimated(true, completion: nil)
    fetchNearbyPlaces(mapView.camera.target)
  }
  
  func getRequestStatus(_id:String) -> JSON{
    var getRequestStatusURL = "http://52.8.212.125/getRequestStatus?_id="+_id
    let requestStatusRes = JSON(url: getRequestStatusURL)
    println(getRequestStatusURL)
    println(requestStatusRes)
    return requestStatusRes
  }
  
  func getUser(requestUserId:String) -> JSON{
    var userReq = "http://52.8.212.125/getUser?userid=" + requestUserId
    let user = JSON(url: userReq)
    println(userReq)
    println(user)
    return user
  }
  
  func createTopicButton(){
    // トピック表示ボタンの生成.
    let myButton = ZFRippleButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    myButton.backgroundColor = UIColor.blackColor()
    myButton.layer.masksToBounds = true
    myButton.setTitle("トピック表示", forState: .Normal)
    myButton.layer.cornerRadius = 5.0
    myButton.layer.position = CGPoint(x: self.view.bounds.width - self.view.bounds.width/3, y:self.view.bounds.height/1.50)
    myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
    self.view.addSubview(myButton)
  }
  
  // トピック表示ボタンイベントのセット.
  func onClickMyButton(sender: UIButton){
    // TODO
  }
  
  func getImage(image:String)->NSData{
    let url = NSURL(string: "http://52.8.212.125/getImage?url=" + image);
    var err: NSError?;
    var getImageRes :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!;
    return getImageRes
  }
  
  func getArrivedTime(_id:String) -> JSON{
    var getArrivedTimeURL = "http://52.8.212.125/updateArrive?_id="+_id
    let requestStatusRes = JSON(url: getArrivedTimeURL)
    println(getArrivedTimeURL)
    println(requestStatusRes)
    return requestStatusRes
  }
  
}

