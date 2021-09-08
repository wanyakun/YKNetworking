//
//  File.swift
//  
//
//  Created by wanyakun on 2021/9/2.
//

import Foundation
import Alamofire

public class YKRequestManager {
    static let defaultManager = YKRequestManager()
    
    var sessionManager: Alamofire.Session!
    let config: YKNetworkingConfig
    var requestRecords: Dictionary<UUID, YKRequest>
    var mutexLock: pthread_mutex_t = pthread_mutex_t()
    var processingQueue: dispatch_queue_concurrent_t
    var allStatusCodes: IndexSet
    
    init() {
        config = YKNetworkingConfig.shared
        requestRecords = [:]
        pthread_mutex_init(&mutexLock, nil)
        processingQueue = DispatchQueue(label: "com.aioser.networking.processing", attributes: .concurrent) as! dispatch_queue_concurrent_t
        allStatusCodes = IndexSet.init(integersIn: 100...500)
        sessionManager = Alamofire.Session(configuration: config.sessionConfiguration, serverTrustManager: config.serverTrustManager)
    }
    
    // MARK: - 公开API
    public func addRequest(_ req: YKRequest) -> Void {
        req.request = buildRequest(req)
        with(request: req, f: addRequestToRecord)
    }
    
    public func cancelRequest(_ req: YKRequest) -> Void {
        req.request?.cancel()
        with(request: req, f: removeRequestFromRecord)
        req.clearHandler()
    }
    
    public func cancelAllRequest() {
        lock()
        let allRequests = requestRecords.values
        unlock()
        for request in allRequests {
            request.stop()
        }
    }
    
    // MARK: - 内部函数
    // MARK: 构建Request相关信息
    func buildRequestUrl(_ request: YKRequest) -> String {
        var detailUrl = request.requestUrl()
        let temp = URL.init(string: detailUrl)
        if (temp != nil) && ((temp?.host) != nil) && ((temp?.scheme) != nil) {
            return detailUrl
        }
        
        if request.useURLFilterInConfig() {
            let filters = config.urlFilters()
            for filter in filters {
                detailUrl = filter.filterUrl(originUrl: detailUrl, request: request)
            }
        } else {
            detailUrl = request.filterUrl(originUrl: detailUrl, request: request)
        }
        
        let baseUrl = request.baseUrl().isEmpty ? config.baseUrl : request.baseUrl()
        var url = URL.init(string: baseUrl)
        if baseUrl.isEmpty == false && baseUrl.hasSuffix("/") == false {
            url = url?.appendingPathComponent("")
        }
        return URL.init(string: detailUrl, relativeTo: url)!.absoluteString
    }

    
    func buildRequestHeader(_ request: YKRequest) -> HTTPHeaders {
        var headers: Dictionary<String, String> = [:]
        if request.useHeaderFilterInConfig() {
            let filters = config.headerFilters()
            for filter in filters {
                headers = filter.filterHeader(headers, request)
            }
        } else {
            headers = request.filterHeader(headers, request)
        }
        return HTTPHeaders(headers)
    }
    
    func buildRequest(_ request: YKRequest) -> Request {
        let method = request.requestMehtod()
        let url = buildRequestUrl(request)
        let parameters = request.requestArgument()
        request.cachedArgument = parameters
        let headers = buildRequestHeader(request)
        switch method {
        case .YKRequestMethodGET:
            if (request.resumableDownloadPath != nil) {
                return httpDownload(downloadPath: request.resumableDownloadPath!,
                               url: url,
                               params: parameters,
                               headers: headers,
                               req: request).uploadProgress(closure: request.resumableDownloadProgressHandler!) as Request
                
            } else {
                return httpRequest(url: url, method: .get, params: parameters, headers: headers, req: request)
            }
        case .YKRequestMethodPOST:
            return httpRequest(url: url, method: .post, params: parameters, headers: headers, req: request)
        case .YKRequestMethodHEAD:
            return httpRequest(url: url, method: .head, params: parameters, headers: headers, req: request)
        case .YKRequestMethodPUT:
            return httpRequest(url: url, method: .put, params: parameters, headers: headers, req: request)
        case .YKRequestMethodDELETE:
            return httpRequest(url: url, method: .delete, params: parameters, headers: headers, req: request)
        case .YKRequestMethodPATCH:
            return httpRequest(url: url, method: .patch, params: parameters, headers: headers, req: request)
        }
    }
    
    // MARK: 处理请求
    func httpRequest(url: String, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders?, req: YKRequest) -> Request {
        if (req.multipartFormDataHandler != nil)  {
            return sessionManager.upload(multipartFormData: req.multipartFormDataHandler!,
                                                to: url, headers: headers) { urlRequest in
                urlRequest.timeoutInterval = req.requestTimeoutInterval()
                urlRequest.allowsCellularAccess = req.allowsCellularAccess()
            }
        } else {
            return sessionManager.request(url,
                                          method: method,
                                          parameters: params,
                                          headers: headers) { urlRequest in
                urlRequest.timeoutInterval = req.requestTimeoutInterval()
                urlRequest.allowsCellularAccess = req.allowsCellularAccess()
            }.validate().responseData(completionHandler: { [weak self] response in
                self?.handleResponse(request: req, response: response)
            })
        }
    }
    
    func httpDownload(downloadPath: String, url: String, params: Parameters?, headers: HTTPHeaders?, req: YKRequest) -> DownloadRequest {
        // 判断下载路径是文件还是文件夹
        var downloadTargertPath: String = ""
        var isDirectory = ObjCBool.init(false)
        if FileManager.default.fileExists(atPath: downloadPath, isDirectory: &isDirectory) == false {
            isDirectory = false
        }
        
        if isDirectory.boolValue {
            let fileName = NSURL.init(string: url)?.lastPathComponent
            downloadTargertPath = (downloadPath as NSString).appendingPathComponent((fileName == nil ? "" : fileName)!)
        } else {
            downloadTargertPath = downloadPath
        }
        // 如果文件存在则删除
        if FileManager.default.fileExists(atPath: downloadTargertPath) {
            try? FileManager.default.removeItem(atPath: downloadTargertPath)
        }
        // 判断断点续传文件是否存在
        let tempURL = incompleteDownloadTempPathForUrl(url)
        let resumeDataFileExists = FileManager.default.fileExists(atPath: tempURL.path)
        let data = try? Data.init(contentsOf: tempURL)
        let resumeDataIsValid = validateResumeData(data)
        let canBeResumed = resumeDataFileExists && resumeDataIsValid
        
        var downloadRequest: DownloadRequest? = nil
        if canBeResumed {
            downloadRequest = sessionManager.download(resumingWith: data!, to: { targetPath, response in
                let url = URL.init(fileURLWithPath: downloadTargertPath, isDirectory: false)
                return (url, [.createIntermediateDirectories])
            }).downloadProgress(closure: req.resumableDownloadProgressHandler!).validate().responseData(completionHandler: { [weak self] response in
                self?.handleDownloadResponse(request: req, response: response)
            })
        } else {
            downloadRequest = sessionManager.download(url, to: { targetPath, response  in
                let url = URL.init(fileURLWithPath: downloadTargertPath, isDirectory: false)
                return (url, [.removePreviousFile, .createIntermediateDirectories])
            }).downloadProgress(closure: req.resumableDownloadProgressHandler!).validate().responseData(completionHandler: { [weak self] response in
                self?.handleDownloadResponse(request: req, response: response)
            })
        }
        return downloadRequest!
    }
    
    // MARK: Resumable Download
    static let cacheFolder = (NSTemporaryDirectory() as NSString).appendingPathComponent("YKNetworkingIncomplete")
    
    func incompleteDownloadTempPathForUrl(_ url: String) -> URL {
        let md5URLString = url.md5
        try? FileManager.default.createDirectory(atPath: YKRequestManager.cacheFolder, withIntermediateDirectories: true, attributes: nil)
        let tempPath = (YKRequestManager.cacheFolder as NSString).appendingPathComponent(md5URLString)
        return URL.init(string: tempPath)!
    }
    
    func validateResumeData(_ data : Data?) -> Bool {
        if (data == nil) {
            return false
        }
        
        let resumeDictionary = try? PropertyListSerialization.propertyList(from: data!, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil)
        if resumeDictionary == nil {
            return false
        }
        return true
    }
    
    // MARK: 处理结果
    func handleResponse(request: YKRequest, response: AFDataResponse<Data>) -> Void {
        request.responseData = response.data
        if let data = response.data {
            request.responseString = String.init(data: data, encoding: .utf8)
        }
        
    }
    
    func handleDownloadResponse(request: YKRequest, response: AFDownloadResponse<Data>) -> Void {
        
    }
}


extension YKRequestManager {
    public func addRequestToRecord(_ req: YKRequest) -> Void {
        requestRecords[req.request!.id] = req
    }
    
    public func removeRequestFromRecord(_ req: YKRequest) -> Void {
        requestRecords.removeValue(forKey: req.request!.id)
    }
 
    func with(request: YKRequest, f: (YKRequest) -> Void) {
        lock()
        f(request)
        unlock()
    }
    
    func lock() -> Void {
        pthread_mutex_lock(&mutexLock)
    }
    
    func unlock() -> Void {
        pthread_mutex_unlock(&mutexLock)
    }
    
}
