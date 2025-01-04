import Foundation
import Moya
import Alamofire

// API 枚举
enum MYKAPI {
    case getVideoInfo(url: String)
    case uploadFile(data: Data)
    // ... 其他 API
}

// 实现 TargetType 协议
extension MYKAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://your-api-base-url.com")!
    }
    
    var path: String {
        switch self {
        case .getVideoInfo:
            return "/video/info"
        case .uploadFile:
            return "/upload"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getVideoInfo:
            return .get
        case .uploadFile:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getVideoInfo(let url):
            return .requestParameters(
                parameters: ["url": url],
                encoding: URLEncoding.default
            )
        case .uploadFile(let data):
            let formData = MultipartFormData(
                provider: .data(data),
                name: "file",
                fileName: "file.mp4",
                mimeType: "video/mp4"
            )
            return .uploadMultipart([formData])
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

// 网络管理类
class MYKNetworkManager {
    static let shared = MYKNetworkManager()
    private let provider = MoyaProvider<MYKAPI>()
    
    private init() {}
    
    // 获取视频信息
    func getVideoInfo(url: String) async throws -> VideoInfo {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.getVideoInfo(url: url)) { result in
                switch result {
                case .success(let response):
                    do {
                        let videoInfo = try response.map(VideoInfo.self)
                        continuation.resume(returning: videoInfo)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // 上传文件
    func uploadFile(data: Data) async throws -> UploadResponse {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.uploadFile(data: data)) { result in
                switch result {
                case .success(let response):
                    do {
                        let uploadResponse = try response.map(UploadResponse.self)
                        continuation.resume(returning: uploadResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// 响应模型
struct VideoInfo: Codable {
    let title: String
    let duration: Double
    let url: String
}

struct UploadResponse: Codable {
    let success: Bool
    let message: String
    let fileUrl: String?
} 