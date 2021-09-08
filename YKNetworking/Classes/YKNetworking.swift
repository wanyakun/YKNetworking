public let YKN = YKNetworking.shared

public class YKNetworking {
    public static let shared = YKNetworking()
    
    public func start(_ request: YKRequest) -> YKRequest {
        let req = request.start()
        return req
    }
}
