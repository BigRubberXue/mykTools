import Foundation

enum MYKNetworkError: Error {
    case invalidURL
    case requestFailed(String)
    case invalidResponse
    case decodingFailed
    case noData
    case unauthorized
    case serverError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "无效的 URL"
        case .requestFailed(let message):
            return "请求失败: \(message)"
        case .invalidResponse:
            return "无效的响应"
        case .decodingFailed:
            return "数据解析失败"
        case .noData:
            return "没有数据"
        case .unauthorized:
            return "未授权"
        case .serverError:
            return "服务器错误"
        }
    }
} 