import SwiftUI
import WebKit

struct MYKWebContainerView: View {
    @State private var urlString = "https://www.baidu.com" // 默认URL
    @State private var webTitle: String = ""
    @State private var isLoading = false
    @State private var estimatedProgress: Double = 0
    @State private var showFloatingButton = false
    
    init() {
//        self.urlString = urlString
//        self.webTitle = webTitle
//        self.isLoading = isLoading
//        self.estimatedProgress = estimatedProgress
//        self.showFloatingButton = showFloatingButton
        print("web - init")
    }
    
    // 处理URL输入
    private func handleURLInput() {
        let processedURL = processURLString(urlString)
        urlString = processedURL
        WebViewStore.shared.load(urlString: processedURL)
    }
    
    // 处理URL字符串
    private func processURLString(_ input: String) -> String {
        let processed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 如果已经是完整的URL格式，直接返回
        if processed.hasPrefix("http://") || processed.hasPrefix("https://") {
            return processed
        }
        
        // 添加 https:// 前缀
        return "https://\(processed)"
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 工具栏
                VStack(spacing: 0) {
                    // 进度条
                    if isLoading {
                        ProgressView(value: estimatedProgress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .frame(height: 3)
                            .transition(.opacity) // 添加渐变动画
                            .animation(.easeInOut, value: isLoading)
                    }
                    
                    // 工具栏
                    HStack(spacing: 12) {
                        // 导航按钮
                        HStack(spacing: 16) {
                            Button(action: {
                                WebViewStore.shared.goBack()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(WebViewStore.shared.canGoBack ? .blue : .gray)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .disabled(!WebViewStore.shared.canGoBack)
                            
                            Button(action: {
                                WebViewStore.shared.goForward()
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(WebViewStore.shared.canGoForward ? .blue : .gray)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .disabled(!WebViewStore.shared.canGoForward)
                        }
                        
                        // 地址栏
                        TextField("输入网址", text: $urlString)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.none)
                            .keyboardType(.URL)
                            .onSubmit {
                                handleURLInput()
                            }
                            .padding(.vertical, 8)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                        
                        HStack(spacing: 16) {
                            // 刷新按钮
                            Button(action: {
                                WebViewStore.shared.reload()
                            }) {
                                Image(systemName: "paperplane")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            
                            // 刷新按钮
                            Button(action: {
                                WebViewStore.shared.reload()
                            }) {
                                Image(systemName: isLoading ? "xmark" : "arrow.clockwise")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                        
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                // WebView
                WebView(urlString: $urlString, webTitle: $webTitle, isLoading: $isLoading, estimatedProgress: $estimatedProgress)
                   .edgesIgnoringSafeArea(.bottom)
            }
            
            // 悬浮按钮
            if showFloatingButton {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // 悬浮按钮点击事件
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(16)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

// 悬浮球视图
struct FloatingBall: View {
    @Binding var showFloatingButton: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            if showFloatingButton {
                // 展开状态：胶囊形状
                HStack(spacing: 12) {
                    Button(action: {
                        clickWebAddBtn()
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(Color.blue)
                .clipShape(Capsule())
                .shadow(radius: 4)
                .transition(.move(edge: .leading)/*.combined(with: .opacity)*/)
                .offset(x: 11)
            } else {
                // 收起状态：半圆形
                Button(action: {
                    withAnimation(.spring()) {
                        showFloatingButton = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation(.spring()) {
                                showFloatingButton = false
                            }
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 44, height: 44)
                            .shadow(radius: 4)
                        
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .offset(x: -22)
            }
        }
        .padding(.leading, 0)
    }
    
    func clickWebAddBtn() {
        let webView = WebViewStore.shared.webView
        // 获取视频元素并打印相关信息
        let jsCode = """
            (function() {
                let videos = document.getElementsByTagName('video');
                if (videos.length > 0) {
                    let video = videos[0];
                    return {
                        src: video.src,
                        currentTime: video.currentTime,
                        duration: video.duration,
                        paused: video.paused,
                        videoCount: videos.length
                    };
                }
                return null;
            })()
        """
        
        // 检查当前datamanager中是否保存了对应originUrl的实例。
        // 如果存在则退出
        
        webView.evaluateJavaScript(jsCode) { (result, error) in
            if let videoInfo = result as? [String: Any] {
//                print("Video Info:")
//                print("- Source:", videoInfo["src"] as? String ?? "N/A")
//                print("- Current Time:", videoInfo["currentTime"] as? Double ?? 0)
//                print("- Duration:", videoInfo["duration"] as? Double ?? 0)
//                print("- Is Paused:", videoInfo["paused"] as? Bool ?? true)
//                print("- Video Count:", videoInfo["videoCount"] as? Int ?? 0)
//                
                let proStr = videoInfo["src"] as? String ?? "N/A"
                let duration = videoInfo["duration"] as? Double ?? 0
                if (proStr == "N/A" || proStr == "") {
                    return
                }
                var currentUrlStr = webView.url?.absoluteString as? String ?? "N/A"
                currentUrlStr = removeURLQuery(urlString: currentUrlStr)
                let originName = creatOriginName(originalString: currentUrlStr)
                let name = getCurrentWebTitle()
                let fileItem = MYKFile.init(originalString: currentUrlStr, processedString: proStr , keyName: originName, title:name, duration: duration)
                
                // 添加到存储中
                MYKAppDataManager.shared.addFile(fileItem, to: 0)
                
            } else if let error = error {
                print("web - Error getting video info:", error)
            } else {
                print("web - No video element found on the page")
            }
        }
    }
}

func creatOriginName(originalString: String) -> String {
    return MYKCrypto.createSHA256String(originalString: originalString)
}

func removeURLQuery(urlString: String) -> String {
    guard let url = URL(string: urlString),
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
        return urlString
    }
    
    var newComponents = components
    newComponents.query = nil  // 移除 query 部分
    
    return newComponents.url?.absoluteString ?? urlString
}


// WebView Store 用于管理 WKWebView 实例
class WebViewStore: ObservableObject {
    static let shared = WebViewStore()
    
    let webView: WKWebView
    
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    
    init() {
        let configuration = WKWebViewConfiguration()
        // 允许在线播放
        configuration.allowsInlineMediaPlayback = true
        // 允许画中画
        configuration.allowsPictureInPictureMediaPlayback = true
        // 设置媒体播放策略
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.setURLSchemeHandler(WebViewCoordinator(), forURLScheme: "baiduboxapp")

        webView = WKWebView(frame: .zero, configuration: configuration)
        setupObservers()
    }
    
    func setupObservers() {
        webView.publisher(for: \.canGoBack)
            .assign(to: &$canGoBack)
        webView.publisher(for: \.canGoForward)
            .assign(to: &$canGoForward)
    }
    
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func goBack() {
        webView.goBack()
    }
    
    func goForward() {
        webView.goForward()
    }
    
    func reload() {
        webView.reload()
    }
}


// WebView 的 UIViewRepresentable 实现
struct WebView: UIViewRepresentable {
    @Binding var urlString: String
    @Binding var webTitle: String
    @Binding var isLoading: Bool
    @Binding var estimatedProgress: Double
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        // 创建 WKWebView 配置
//        let configuration = WKWebViewConfiguration()
        print("makeUIView: WKWebView is being created")

        // 创建 WebView
        let webView = WebViewStore.shared.webView
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
//        if let url = URL(string: urlString) {
//            webView.load(URLRequest(url: url))
//        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // 更新逻辑
        print("updateUIView: WKWebView is being updated")
    }
    
}

class WebViewCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKURLSchemeHandler {
//    var parent: WebView
    
//    init(_ parent: WebView) {
//        self.parent = parent
//    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        print("web - 🔄 页面加载失败")
    }
    
    // 决定是否允许加载
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 打印请求 URL
        if let url = navigationAction.request.url {
            print("web - ⚡️ 准备加载 URL:", url.absoluteString)
            
            // 检查 URL 是否包含 "scheme=baiduboxapp"
            if url.absoluteString.contains("scheme=baiduboxapp") {
                print("web - 拦截到包含 'scheme=baiduboxapp' 的 URL:", url.absoluteString)
                decisionHandler(.cancel) // 拦截请求
                return
            }
            
            // 检查是否是外部应用跳转
            if !url.absoluteString.hasPrefix("http") && !url.absoluteString.hasPrefix("https") {
                print("web - 🚀 检测到外部应用跳转:", url.absoluteString)
                
                // 检查是否可以打开该 URL
                if UIApplication.shared.canOpenURL(url) {
                    print("web - ✅ 可以打开该 URL")
                    UIApplication.shared.open(url) { success in
                        if success {
                            print("web - ✅ 成功打开外部应用")
                        } else {
                            print("web - ❌ 打开外部应用失败")
                        }
                    }
                    decisionHandler(.cancel)
                    return
                } else {
                    print("web - ❌ 无法打开该 URL")
                }
            }
        }
        
        decisionHandler(.allow)
    }
    
    // 开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        parent.isLoading = true
        print("web - 🔄 开始加载页面")
    }
    
    // 加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        parent.isLoading = false
//        webView.webTitle = webView.title ?? ""
//        webView.urlString = webView.url?.absoluteString ?? ""
        print("web - ✅ 页面加载完成")
    }
    
    // 加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        parent.isLoading = false
        print("web - ❌ 页面加载失败:", error.localizedDescription)
    }
    
    // 监听进度
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        parent.estimatedProgress = webView.estimatedProgress
    }
    
    // MARK: - WKUIDelegate
    
    // 处理新窗口打开
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("web - 🔄 请求新窗口打开:", navigationAction.request.url?.absoluteString ?? "unknown URL")
        
        // 在当前窗口打开
        webView.load(navigationAction.request)
        return nil
    }
    
    // MARK: - WKURLSchemeHandler
    // 处理自定义 URL Scheme
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else { return }
        
        // 获取请求的 scheme
        let scheme = url.scheme?.lowercased() ?? ""
        
        // 处理不同类型的请求
        switch scheme {
        case "http", "https":
            handleHTTPRequest(urlSchemeTask)
            
        case "baiduboxapp":
            handleBaiduBoxAppRequest(urlSchemeTask)
            
        default:
            // 处理其他自定义 scheme
            let response = HTTPURLResponse(
                url: url,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didFinish()
        }
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        // 取消请求的处理
    }
    
    private func handleHTTPRequest(_ urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else { return }
        
        // 使用 URLSession 处理原始请求
        let session = URLSession.shared
        let task = session.dataTask(with: urlSchemeTask.request) { data, response, error in
            if let error = error {
                print("web - HTTP 请求错误:", error.localizedDescription)
                return
            }
            
            // 返回响应和数据
            if let response = response as? HTTPURLResponse {
                urlSchemeTask.didReceive(response)
            }
            
            if let data = data {
                urlSchemeTask.didReceive(data)
            }
            
            urlSchemeTask.didFinish()
        }
        task.resume()
    }
    
    private func handleBaiduBoxAppRequest(_ urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else { return }
        
        // 处理 baiduboxapp:// 请求
        print("web - 拦截到 baiduboxapp 请求:", url.absoluteString)
        
        // 示例：直接返回一个自定义响应
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "text/plain"]
        )!
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive("BaiduBoxApp request intercepted".data(using: .utf8)!)
        urlSchemeTask.didFinish()
    }
}

func getCurrentWebTitle() -> String {
    let webView = WebViewStore.shared.webView
    return webView.title ?? "Untitled"
}

// 使用示例:
// let title = getCurrentWebTitle()
// print("Current page title:", title) 
