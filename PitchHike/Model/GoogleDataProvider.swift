//
//  GoogleDataProvider.swift
//  PitchHike
//
//  Created by NinjaSE3 on 2015/06/30.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class GoogleDataProvider {
  
  let apiKey = "AIzaSyA_Jym4ff-n30IIsKx8B_EK8-QYsb-FBPs"
  var photoCache = [String:UIImage]()
  var placesTask = NSURLSessionDataTask()
  var session: NSURLSession {	
    return NSURLSession.sharedSession()
  }
  
  struct location{
    static var lat = ""
    static var lng = ""
  }
  
  
  func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, types:[String], completion: (([GooglePlace]) -> Void)) -> ()
  {
    var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiKey)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true"
    
    
    let typesString = types.count > 0 ? join("|", types) : "food"
    urlString += "&types=\(typesString)"
    urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    
    if placesTask.taskIdentifier > 0 && placesTask.state == .Running {
      placesTask.cancel()
    }
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    placesTask = session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      var placesArray = [GooglePlace]()
      if let json = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as? NSDictionary {
        if let results = json["results"] as? NSArray {
          for rawPlace:AnyObject in results {
            let place = GooglePlace(dictionary: rawPlace as! NSDictionary, acceptedTypes: types)
            placesArray.append(place)
            if let reference = place.photoReference {
              self.fetchPhotoFromReference(reference) { image in
                place.photo = image
              }
            }
          }
        }
      }
      dispatch_async(dispatch_get_main_queue()) {
        completion(placesArray)
      }
    }
    placesTask.resume()
  }


  
  
  func fetchDirectionsFrom(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: ((String?) -> Void)) -> ()
  {
    let urlString = "https://maps.googleapis.com/maps/api/directions/json?key=\(apiKey)&origin=\(from.latitude),\(from.longitude)&destination=\(to.latitude),\(to.longitude)&mode=walking"
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
      UIApplication.sharedApplication().networkActivityIndicatorVisible = false
      var encodedRoute: String?
      if let json = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as? [String:AnyObject] {
        if let routes = json["routes"] as AnyObject? as? [AnyObject] {
          if let route = routes.first as? [String : AnyObject] {
            if let polyline = route["overview_polyline"] as AnyObject? as? [String : String] {
              if let points = polyline["points"] as AnyObject? as? String {
                encodedRoute = points
                
                // DirectionData取得
                self.calculateTotalDistanceAndDuration(urlString)
                
                // TODO 先生の検索処理
                //AppDelegateのインスタンスを取得
                var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                location.lat = String(stringInterpolationSegment: to.latitude)
                location.lng = String(stringInterpolationSegment: to.longitude)
                
                println(location.lat)
                println(location.lng)
                
                //req:lat,lng,language,userid res:requestStatus
                let requestTeacherRes = self.requestTeacher(location.lat, lng: location.lng, lang: "English", userid: "000001")
                println(requestTeacherRes["status"])
                
                // 現在日時を取得
                var date1 = NSDate()
                while(true){
                  let requestStatusRes = self.getRequestStatus(requestTeacherRes["_id"].toString(pretty: true))
                  println(requestStatusRes["status"])
                  
                  sleep(1)
                  // 現在日時を取得
                  var date2 = NSDate()
                  var time  = Float(date2.timeIntervalSinceDate(date1))
                  println(time)
                  
                  var status:String = requestStatusRes["status"].toString(pretty: true)
                  if( requestStatusRes["status"].toString(pretty: true) == "req" ){
                    break
                  }
                  if(time > Float(5)){
                    appDelegate._error = "TimeOut"
                    break
                  }
                }
                if(appDelegate._error != "TimeOut"){
                  //appDelegateの変数を操作 マッチングした先生と生徒の_id
                  appDelegate._requestStatusID = requestTeacherRes["_id"].toString(pretty: true)
                  appDelegate._screen = "Matching"
                }else{
                  print("Search失敗")
                }
              }
            }
          }
        }
      }
      dispatch_async(dispatch_get_main_queue()) {
        completion(encodedRoute)
      }
    }.resume()
  }
  
  
  //現在地から指定値までの時間、距離を計算
  func calculateTotalDistanceAndDuration(urlString: String) {
    let json = JSON(url: urlString)
    
    
    // todo 特定の要素の取り出し トータル距離と時間算出
    let legs = json["routes"][0]["legs"]
    println(legs)

    var totalDistanceInMeters = 0
    var totalDurationInSeconds = 0
    
    for leg in legs {
//      totalDistanceInMeters += leg["distance"]
   //   totalDurationInSeconds += (leg["duration"] as Dictionary<NSObject, AnyObject>)["value"] as UInt
    }

    println(totalDistanceInMeters)
    
//
//    let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
//    totalDistance = "Total Distance: \(distanceInKilometers) Km"
//    
//    
//    let mins = totalDurationInSeconds / 60
//    let hours = mins / 60
//    let days = hours / 24
//    let remainingHours = hours % 24
//    let remainingMins = mins % 60
//    let remainingSecs = totalDurationInSeconds % 60
//    
//    totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
  }
  
  
  func fetchPhotoFromReference(reference: String, completion: ((UIImage?) -> Void)) -> ()
  {
    if let photo = photoCache[reference] as UIImage! {
      completion(photo)
    } else {
      let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(reference)&key=\(apiKey)"
      UIApplication.sharedApplication().networkActivityIndicatorVisible = true
      session.downloadTaskWithURL(NSURL(string: urlString)!) {url, response, error in
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        let downloadedPhoto = UIImage(data: NSData(contentsOfURL: url)!)
        self.photoCache[reference] = downloadedPhoto
        dispatch_async(dispatch_get_main_queue()) {
          completion(downloadedPhoto)
        }
      }.resume()
    }
  }
  
  func requestTeacher(lat:String,lng:String,lang:String,userid:String) -> JSON{
    var requestTeacherURL = "http://52.8.212.125/requestTeacher?lat=" + String(lat) + "&lng="+String(lng)+"&lang=" + String(lang) + "&userid=" + String(userid)
    let requestTeacherRes = JSON(url: requestTeacherURL)
    println(requestTeacherURL)
    println(requestTeacherRes)
    return requestTeacherRes
  }
  
  func getRequestStatus(_id:String) -> JSON{
    var getRequestStatusURL = "http://52.8.212.125/getRequestStatus?_id="+_id
    let requestStatusRes = JSON(url: getRequestStatusURL)
    println(getRequestStatusURL)
    println(requestStatusRes)
    return requestStatusRes
  }

}
