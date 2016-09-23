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
        let teacherReq = "http://localhost:8080/requestTeacher?lat=" + String(lat) + "&lng="+String(lng)+"&lang=" + String(lang) + "&userid=" + String(userid)
        let requestStatus = JSON(url: teacherReq)
        print(teacherReq)
        print(requestStatus)
        return requestStatus
    }

    func getRequestStatus(requestStatus:String) -> JSON{
        let statusReq = "http://localhost:8080/getRequestStatus?_id=" + requestStatus
        let status = JSON(url: statusReq)
        print(statusReq)
        print(status)
        return status
    }
    
    func getUser(requestUserId:String) -> JSON{
        let userReq = "http://localhost:8080/getUser?userid=" + requestUserId
        let user = JSON(url: userReq)
        print(userReq)
        print(user)
        return user
    }
    
    
}
