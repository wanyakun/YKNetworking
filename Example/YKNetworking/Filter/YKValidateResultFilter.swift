//
//  YKValidateResultFilter.swift
//  YKNetworking_Example
//
//  Created by wanyakun on 2022/8/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import YKNetworking

//struct YKResponseStatus {
//    let appName: String
//    let duration: Float
//    let errorCode: String
//    let memo: String
//    let replyCode: String
//    let replyText: String
//    let success: Bool
//}
//
//struct YKResponse {
// let body: Any
// let status: YKResponseStatus
//}

public class YKValidateResultFilter: YKValidateResultFilterProtocol {
    public func filterValidateResult(_ request: YKRequest) -> Bool {
        let json = request.responseJSON as! Dictionary<String, Any>
        let status = json["status"] as! Dictionary<String, Any>
        let success = status["success"] as! Bool
        if (!success) {
            let replyCode = status["replyCode"] as! String
            if (request.replyCodes().contains(replyCode)) {
                return true
            }
            return false
        }
        return true
    }
}
