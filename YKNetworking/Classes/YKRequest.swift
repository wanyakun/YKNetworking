//
//  File.swift
//  
//
//  Created by wanyakun on 2021/9/1.
//

import Foundation
import Alamofire

public typealias YKRequestCompletionClosure = (_ request: YKRequest) -> Void
public typealias YKRequestRedirectionClosure = (_ request: YKRequest, _ response: HTTPURLResponse) -> Void
public typealias YKRequestPorgressHandler = (_ progress: Progress) -> Void
public typealias YKRequestMultipartFormClosure = (_ multipartFormData: MultipartFormData) -> Void
open class YKRequest: YKURLFilterProtocol, YKHeaderFilterProtocol {
    public var request: Request?
    
    public var responseData: Data?
    public var responseString: String?
    public var responseJSON: Any?
    
    // 成功回调
    var successHandler: YKRequestCompletionClosure?
    // 失败回调
    var failedHandler: YKRequestCompletionClosure?
    // 下载进度回调
    var resumableDownloadProgressHandler: YKRequestPorgressHandler?
    // 上传from设置回调
    var multipartFormDataHandler: YKRequestMultipartFormClosure?
    
    // MARK: subclass need override
    public func baseUrl() -> String {
        return ""
    }
    
    public func requestUrl() -> String {
        return ""
    }
    
    public func requestTimeoutInterval() -> TimeInterval {
        return 30
    }
    
    public func requestArgument() -> [String: Any]? {
        return nil
    }
    
    public func requestMehtod() -> YKRequestMethod {
        return YKRequestMethod.YKRequestMethodPOST
    }
    
    public func allowsCellularAccess() -> Bool {
        return true
    }
    
    public func useURLFilterInConfig() -> Bool {
        return true
    }
    
    public func useHeaderFilterInConfig() -> Bool {
        return true
    }
    
    public func useCachePathFilterInConfig() -> Bool {
        return true
    }
    
    public func useSuccessFilterInConfig() -> Bool {
        return true
    }
    
    public func useFailedFilterInConfig() -> Bool {
        return true
    }
    
    public func useValidateResultFilterInConfig() -> Bool {
        return true
    }
    
    // MARK: - request config
    // request identify
    public let tag: Int? = 0
    // store additional infomator of the request
    public var userInfo: Dictionary<String, Any>?
    // cache request argument from requestArgument method, it wil cache the argument with first call requestArgument method
    public var cachedArgument: [String: Any]?
    // use to perform resumable download request
    public var resumableDownloadPath: String?
    
    public func success(_ closure: @escaping YKRequestCompletionClosure) -> Self {
        successHandler = closure
        return self
    }
    
    public func failed(_ closure: @escaping YKRequestCompletionClosure) -> Self {
        failedHandler = closure
        return self
    }
    
    public func downloadProgress(_ closure: @escaping YKRequestPorgressHandler) -> Self {
        resumableDownloadProgressHandler = closure
        return self
    }
    
    public func multipartFormData(_ closure: @escaping YKRequestMultipartFormClosure) -> Self {
        multipartFormDataHandler = closure
        return self
    }
    
    public func clearHandler() {
        successHandler = nil
        failedHandler = nil
    }
    
    // MARK: protocol subclass need override
    public func filterHeader(_ originHeader: Dictionary<String, String>, _ request: YKRequest) -> Dictionary<String, String> {
        return originHeader
    }
    
    public func filterUrl(originUrl: String, request: YKRequest) -> String {
        return originUrl
    }
    
    // MARK: - all api
    public func start() -> Self {
        // 将request添加到manager中
        YKRequestManager.defaultManager.addRequest(self)
        return self
    }
    
    public func stop() {
        // 将request从manager中取消掉
        YKRequestManager.defaultManager.cancelRequest(self)
    }
}

// MARK: - request and response infomation
extension YKRequest {
    public var requestTask: URLSessionTask? {
        return request?.task
    }
    public var currentRequest: URLRequest? {
        return requestTask?.currentRequest
    }
    
    public var originalRequest: URLRequest? {
        return requestTask?.originalRequest
    }
    
    public var response: HTTPURLResponse? {
        return requestTask?.response as? HTTPURLResponse
    }
    
    public var responseStatusCode: Int {
        return response?.statusCode ?? 0
    }
    
    public var responseHeader: Dictionary<AnyHashable, Any>? {
        return response?.allHeaderFields
    }
    
    public var isCancelled: Bool {
        if (requestTask == nil) {
            return false
        }
        return requestTask?.state == URLSessionTask.State.canceling
    }
    
    public var isExecuting: Bool {
        if (requestTask == nil) {
            return false
        }
        return requestTask?.state == URLSessionTask.State.running
    }
}
