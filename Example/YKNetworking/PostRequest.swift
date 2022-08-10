//
//  PostRequest.swift
//  YKNetworking_Example
//
//  Created by wanyakun on 2022/8/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import YKNetworking

class PostRequest: YKRequest {
    override func requestUrl() -> String {
        return "/api/lcp/v1/AppListInquiry"
    }
    
    override func requestArgument() -> [String : Any]? {
        let params: [String: Any] = [
            "teamId": "664098401391140864"
        ]
        return params
    }
}
