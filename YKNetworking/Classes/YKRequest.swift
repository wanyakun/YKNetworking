//
//  File.swift
//  
//
//  Created by wanyakun on 2021/9/1.
//

import Foundation
import Alamofire

public protocol YKRequestStatusTrackerProtocol {
    func requestWillStart(_ request: YKRequest)
    func requestWillStop(_ request: YKRequest)
    func requestDidStop(_ request: YKRequest)
}

public typealias YKRequestCompletionClosure = (_ request: YKRequest) -> Void
public typealias YKRequestRedirectionClosure = (_ request: YKRequest, _ response: HTTPURLResponse) -> Void
public typealias YKRequestPorgressHandler = (_ progress: Progress) -> Void
public typealias YKRequestMultipartFormClosure = (_ multipartFormData: MultipartFormData) -> Void
open class YKRequest: YKURLFilterProtocol, YKHeaderFilterProtocol, YKSuccessFilterProtocol, YKFailedFilterProtocol, YKValidateResultFilterProtocol {
    public var request: Request?
    
    public var responseData: Data?
    public var responseString: String?
    public var responseJSON: Any?
    public var error: Error?
    
    // 成功回调
    var successHandler: YKRequestCompletionClosure?
    // 失败回调
    var failedHandler: YKRequestCompletionClosure?
    // 重定向回调
    var redirectionHandler: YKRequestRedirectionClosure?
    // 下载进度回调
    var resumableDownloadProgressHandler: YKRequestPorgressHandler?
    // 上传from设置回调
    var multipartFormDataHandler: YKRequestMultipartFormClosure?
    
    public init() {
        //
    }
    
    // MARK: subclass need override
    open func baseUrl() -> String {
        return ""
    }
    
    open func requestUrl() -> String {
        return ""
    }
    
    open func requestTimeoutInterval() -> TimeInterval {
        return 30
    }
    
    open func requestArgument() -> [String: Any]? {
        return nil
    }
    
    open func requestMehtod() -> YKRequestMethod {
        return YKRequestMethod.YKRequestMethodPOST
    }
    
    open func encoding() -> ParameterEncoding {
        return JSONEncoding.prettyPrinted
    }
    
    open func replyCodes() -> Array<String> {
        return []
    }
    
    open func allowsCellularAccess() -> Bool {
        return true
    }
    
    open func useURLFilterInConfig() -> Bool {
        return true
    }
    
    open func useHeaderFilterInConfig() -> Bool {
        return true
    }
    
    open func useParamsFilterInConfig() -> Bool {
        return true
    }
    
    open func useCachePathFilterInConfig() -> Bool {
        return true
    }
    
    open func useSuccessFilterInConfig() -> Bool {
        return true
    }
    
    open func useFailedFilterInConfig() -> Bool {
        return true
    }
    
    open func useValidateResultFilterInConfig() -> Bool {
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
    
    public var requestStatusTrackers: Array<YKRequestStatusTrackerProtocol> = []
    
    public func success(_ closure: @escaping YKRequestCompletionClosure) -> Self {
        successHandler = closure
        return self
    }
    
    public func failed(_ closure: @escaping YKRequestCompletionClosure) -> Self {
        failedHandler = closure
        return self
    }
    
    public func redirection(_ closure: @escaping YKRequestRedirectionClosure) -> Self {
        redirectionHandler = closure
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
    open func filterHeader(_ originHeader: Dictionary<String, String>, _ request: YKRequest) -> Dictionary<String, String> {
        return originHeader
    }
    
    open func filterUrl(originUrl: String, request: YKRequest) -> String {
        return originUrl
    }
    
    open func filterSuccess(_ request: YKRequest) {
        // to be override
    }
    
    open func filterFailed(_ error: Error, _ request: YKRequest) {
        // to be override
    }
    
    open func filterValidateResult(_ request: YKRequest) -> Bool {
        // to be override
        return true
    }
    
    
    
    // MARK: - all api
    public func start() -> Self {
        willStartCallBack()
        // 将request添加到manager中
        YKRequestManager.defaultManager.addRequest(self)
        return self
    }
    
    public func stop() {
        willStopCallBack()
        // 将request从manager中取消掉
        YKRequestManager.defaultManager.cancelRequest(self)
        didStopCallBack()
    }
    
    public func addStatusTracker(_ tracker: YKRequestStatusTrackerProtocol) {
        requestStatusTrackers.append(tracker)
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

// MARK: - status tracker
extension YKRequest {
    public func willStartCallBack() {
        for tracker in requestStatusTrackers {
            tracker.requestWillStart(self)
        }
    }
    
    public func willStopCallBack() {
        for tracker in requestStatusTrackers {
            tracker.requestWillStop(self)
        }
    }
    
    public func didStopCallBack() {
        for tracker in requestStatusTrackers {
            tracker.requestDidStop(self)
        }
    }
}
