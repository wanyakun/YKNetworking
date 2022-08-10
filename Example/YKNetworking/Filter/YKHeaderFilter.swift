//
//  YKHeaderFilter.swift
//  YKNetworking_Example
//
//  Created by wanyakun on 2022/8/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import YKNetworking

open class YKHeaderFilter: YKHeaderFilterProtocol {
    public func filterHeader(_ originHeader: [String : String], _ request: YKRequest) -> [String : String] {
        let accessToken = "1ef0f43fc3024e1d83ee471421acf996" // 从Passport中获取
        let targetHeader = [
            "Content-Type": "application/json",
            "accessToken": accessToken
        ].merging(originHeader) { (first, _) in
            return first
        }
        return targetHeader
    }
}
