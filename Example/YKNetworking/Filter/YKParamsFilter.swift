//
//  YKParamsFilter.swift
//  YKNetworking_Example
//
//  Created by wanyakun on 2022/8/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import YKNetworking

open class YKParamsFilter: YKParamsFilterProtocol {
    public func filterParams(_ originParams: [String : Any], _ request: YKRequest) -> [String : Any] {
        let userId = "664094994122182656" // 从Passport中获取
        let context = [
            "channel": "iOS",
            "entityId": "664098401391140864",
            "locale": "",
            "orgId": "",
            "privileges": "",
            "roles": "",
            "serviceId": "",
            "userId": userId
        ]
        let targetParams = [
            "context": context
        ].merging(originParams) { (first, _) in
            return first
        }
        return targetParams
    }
}
