import SwiftUI
import Network

struct MYKSettingsView: View {
    @State private var isWifiEnabled = false
    @State private var isCellularEnabled = false
    @State private var networkStatus = "正在检查网络状态..."
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("通用")) {
                    // 网络状态
                    HStack {
                        Image(systemName: getNetworkIcon())
                            .foregroundColor(getNetworkColor())
                        Text("网络状态")
                        Spacer()
                        Text(networkStatus)
                            .foregroundColor(.gray)
                    }
                    
                    // WiFi 权限
                    HStack {
                        Image(systemName: "wifi")
                        Text("WiFi")
                        Spacer()
                        Button(action: {
                            openSettings()
                        }) {
                            Text(isWifiEnabled ? "已开启" : "未开启")
                                .foregroundColor(isWifiEnabled ? .green : .gray)
                        }
                    }
                    
                    // 蜂窝数据权限
                    HStack {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                        Text("蜂窝网络")
                        Spacer()
                        Button(action: {
                            openSettings()
                        }) {
                            Text(isCellularEnabled ? "已开启" : "未开启")
                                .foregroundColor(isCellularEnabled ? .green : .gray)
                        }
                    }
                }
                
                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("设置")
        }
        .onAppear {
            startMonitoringNetwork()
        }
        .onDisappear {
            monitor.cancel()
        }
    }
    
    // 开始监控网络状态
    private func startMonitoringNetwork() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isWifiEnabled = path.usesInterfaceType(.wifi)
                self.isCellularEnabled = path.usesInterfaceType(.cellular)
                
                switch path.status {
                case .satisfied:
                    self.networkStatus = "已连接"
                case .unsatisfied:
                    self.networkStatus = "未连接"
                case .requiresConnection:
                    self.networkStatus = "需要连接"
                @unknown default:
                    self.networkStatus = "未知状态"
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    // 获取网络状态图标
    private func getNetworkIcon() -> String {
        if isWifiEnabled {
            return "wifi"
        } else if isCellularEnabled {
            return "antenna.radiowaves.left.and.right"
        } else {
            return "network.slash"
        }
    }
    
    // 获取网络状态颜色
    private func getNetworkColor() -> Color {
        if isWifiEnabled || isCellularEnabled {
            return .green
        } else {
            return .gray
        }
    }
    
    // 打开系统设置
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// 预览
#Preview {
    MYKSettingsView()
} 