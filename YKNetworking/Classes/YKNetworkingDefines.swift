//
//  YKDefines.swift
//  
//
//  Created by wanyakun on 2021/9/1.
//

public enum YKRequestMethod {
    case YKRequestMethodGET
    case YKRequestMethodPOST
    case YKRequestMethodHEAD
    case YKRequestMethodPUT
    case YKRequestMethodDELETE
    case YKRequestMethodPATCH
}

public enum YKError:Error {
    case JSONSerializationFailed
    case InvalidStatusCode  // Alamofire validate会校验status和content-type, 暂时用不到
    case InvalidJSONFormat  // 自定义JSON格式校验，目前暂时没有地方使用
    case InvalidResult
}
