//
//  File.swift
//  
//
//  Created by wanyakun on 2021/9/5.
//

import Foundation
import CommonCrypto

public extension String {
    var md5: String {
        if self.isEmpty {
            return ""
        }
        // 源字符串
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        // 加密结果
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        // 加密
        CC_MD5(str!, strLen, result)
        // 加密结果转换
        let hash = NSMutableString()
        
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate()
        return hash as String
    }
}
