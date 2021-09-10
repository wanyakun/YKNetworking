//
//  GetRequest.swift
//  YKNetworking_Example
//
//  Created by wanyakun on 2021/9/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import YKNetworking

class GetRequest: YKRequest {
    override func requestUrl() -> String {
        return "https://d7.weather.com.cn/fishing/api/v1/tab?lon=121.473701&lat=31.230416"
    }
    
    override func requestMehtod() -> YKRequestMethod {
        return .YKRequestMethodGET
    }
}
