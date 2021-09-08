//
//  YKDefines.swift
//  
//
//  Created by wanyakun on 2021/9/1.
//

public enum YKRequestValidationError: Int {
    case YKRequestValidationErrorInvalidStatusCode = -8
    case YKRequestValidationErrorInvalidJSONFormat = -9
    case YKRequestValidationErrorInvalidResult = -10
}

public enum YKRequestMethod {
    case YKRequestMethodGET
    case YKRequestMethodPOST
    case YKRequestMethodHEAD
    case YKRequestMethodPUT
    case YKRequestMethodDELETE
    case YKRequestMethodPATCH
}
