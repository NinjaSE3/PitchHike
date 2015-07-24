//
//  WebAPI.swift
//  PitchHike
//
//  Created by Takaaki on 2015/07/07.
//  Copyright (c) 2015年 NinjaSE3. All rights reserved.
//

import Foundation

class WebAPI {
    
    func requestTeacher(lat:String,lng:String,lang:String,userid:String) -> JSON{
        var teacherReq = "http://52.8.212.125/requestTeacher?lat=" + String(lat) + "&lng="+String(lng)+"&lang=" + String(lang) + "&userid=" + String(userid)
        let requestStatus = JSON(url: teacherReq)
        println(teacherReq)
        println(requestStatus)
        return requestStatus
    }

    func getRequestStatus(requestStatus:String) -> JSON{
        var statusReq = "http://52.8.212.125/getRequestStatus?_id=" + requestStatus
        let status = JSON(url: statusReq)
        println(statusReq)
        println(status)
        return status
    }
    
    func getUser(requestUserId:String) -> JSON{
        var userReq = "http://52.8.212.125/getUser?userid=" + requestUserId
        let user = JSON(url: userReq)
        println(userReq)
        println(user)
        return user
    }
    
    
}
