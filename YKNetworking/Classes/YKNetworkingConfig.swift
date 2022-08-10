//
//  YKNetworkingConfig.swift
//  
//
//  Created by wanyakun on 2021/9/2.
//

import Foundation
import Alamofire

// MARK: - Protocol
public protocol YKURLFilterProtocol {
    func filterUrl(originUrl: String, request: YKRequest) -> String
}

public protocol YKHeaderFilterProtocol {
    func filterHeader(_ originHeader: [String: String], _ request: YKRequest) -> [String: String]
}

public protocol YKParamsFilterProtocol: Encodable {
    func filterParams(_ originParams: [String: Any], _ request: YKRequest) -> [String: Any]
}

public protocol YKCachePathFilterProtocol {
    func filterCachePath(_ originPath: String, _ request: YKRequest) -> String
}

public protocol YKFailedFilterProtocol {
    func filterFailed(_ error: Error, _ request: YKRequest) -> Void
}

public protocol YKSuccessFilterProtocol {
    func filterSuccess(_ request: YKRequest) -> Void
}

public protocol YKValidateResultFilterProtocol {
    func filterValidateResult(_ request: YKRequest) -> Bool
}

// MARK: - YKBLNetworkingConfig
public class YKNetworkingConfig {
    public static let shared = YKNetworkingConfig()
    
    // MARK: property
    public var baseUrl: String = ""
    public var serverTrustManager: ServerTrustManager? = nil
    public var sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.af.default
    
    private var _urlFilters: Array<YKURLFilterProtocol> = []
    private var _headerFilters: Array<YKHeaderFilterProtocol> = []
    private var _paramsFilters: Array<YKParamsFilterProtocol> = []
    private var _cachePathFilters: Array<YKCachePathFilterProtocol> = []
    private var _successFilters: Array<YKSuccessFilterProtocol> = []
    private var _failedFilters: Array<YKFailedFilterProtocol> = []
    private var _validateResultFilters: Array<YKValidateResultFilterProtocol> = []
    
    public func addUrlFilter(filter: YKURLFilterProtocol) {
        _urlFilters.append(filter)
    }
    
    public func clearUrlFilter() {
        _urlFilters.removeAll()
    }
    
    public func addHeaderFilter(filter: YKHeaderFilterProtocol) {
        _headerFilters.append(filter)
    }
    
    public func clearHeaderFilter() {
        _headerFilters.removeAll()
    }
    
    public func addParamsFilter(filter: YKParamsFilterProtocol) {
        _paramsFilters.append(filter)
    }
    
    public func clearParamsFilter() {
        _paramsFilters.removeAll()
    }
    
    public func addCachePathFilter(filter: YKCachePathFilterProtocol) {
        _cachePathFilters.append(filter)
    }
    
    public func clearCachePathFilter() {
        _cachePathFilters.removeAll()
    }
    
    public func addSuccessFilter(filter: YKSuccessFilterProtocol) {
        _successFilters.append(filter)
    }
    
    public func clearSuccessFilter() {
        _successFilters.removeAll()
    }
    
    public func addFailedFilter(filter: YKFailedFilterProtocol) {
        _failedFilters.append(filter)
    }
    
    public func clearFailedFilter() {
        _failedFilters.removeAll()
    }
    
    public func addValidateResultFilter(filter: YKValidateResultFilterProtocol) {
        _validateResultFilters.append(filter)
    }
    
    public func clearValidateResultFilter() {
        _validateResultFilters.removeAll()
    }
    
    public func urlFilters() -> Array<YKURLFilterProtocol> {
        return _urlFilters
    }
    
    public func headerFilters() -> Array<YKHeaderFilterProtocol> {
        return _headerFilters
    }
    
    public func paramsFilters() -> Array<YKParamsFilterProtocol> {
        return _paramsFilters
    }
    
    public func cachePathFitlers() -> Array<YKCachePathFilterProtocol> {
        return _cachePathFilters
    }
    
    public func successFilters() -> Array<YKSuccessFilterProtocol> {
        return _successFilters
    }
    
    public func failedFilters() -> Array<YKFailedFilterProtocol> {
        return _failedFilters
    }
    
    public func validateResultFitlers() -> Array<YKValidateResultFilterProtocol> {
        return _validateResultFilters
    }
}
