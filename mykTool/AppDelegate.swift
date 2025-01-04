import UIKit
import SwiftUI

//@UIApplicationMain
//@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var launchWindow: UIWindow?
    private var fpsBallWindow: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 1. 创建并显示启动窗口
        showLaunchScreen()
        
        // 2. 延迟3秒后切换到主窗口
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showMainWindow()
            self.removeLaunchScreen()
        }
        // 初始化主 window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: MYKContentView()) // 替换为你的根视图
        window?.makeKeyAndVisible()
        print("Main window created: \(window != nil)")
        print("Main window is hidden: \(window?.isHidden ?? true)")

        // 添加悬浮球
        addFPSBall()
        
        return true
    }
    
    // func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //     print("AppDelegate: application didFinishLaunchingWithOptions")
        
    //     // 初始化启动屏
    //     launchWindow = UIWindow(frame: UIScreen.main.bounds)
    //     launchWindow?.rootViewController = UIHostingController(rootView: LaunchScreenView())
    //     launchWindow?.makeKeyAndVisible()

    //     // 模拟启动屏显示时间
    //     DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    //         print("AppDelegate: removing launch screen")
    //         self.removeLaunchScreen()
    //     }

    //     return true
    // }
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = UIHostingController(rootView: MYKContentView())
//        window?.makeKeyAndVisible()
//        return true
//    }


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }

    private func addFPSBall() {
        // let fpsBallView = FPSBallView()
        // let hostingController = UIHostingController(rootView: fpsBallView)
        
        // // 创建悬浮球窗口
        // fpsBallWindow = UIWindow(frame: UIScreen.main.bounds)
        // fpsBallWindow?.windowLevel = UIWindow.Level.statusBar + 1
        // fpsBallWindow?.rootViewController = hostingController
        // fpsBallWindow?.isHidden = false
        
        // 创建悬浮球窗口
        fpsBallWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        // 设置悬浮球窗口的根视图
        let fpsBallView = FPSBallView()
        fpsBallWindow?.rootViewController = UIHostingController(rootView: fpsBallView)
        
        // 设置悬浮球窗口属性
        fpsBallWindow?.windowLevel = .statusBar
        fpsBallWindow?.backgroundColor = .clear
        fpsBallWindow?.isHidden = false

        // 调试信息
        print("fpsBallWindow created: \(fpsBallWindow != nil)")
        print("fpsBallWindow is hidden: \(fpsBallWindow?.isHidden ?? true)")
    }


    private func showLaunchScreen() {
        // 创建启动窗口
        launchWindow = UIWindow(frame: UIScreen.main.bounds)
        
        // 设置启动窗口的根视图
        let launchView = LaunchScreenView()
        launchWindow?.rootViewController = UIHostingController(rootView: launchView)
        
        // 设置启动窗口为最高层级并显示
        launchWindow?.windowLevel = .alert + 1
        launchWindow?.makeKeyAndVisible()
    }
    
    private func showMainWindow() {
        // 创建主窗口
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 设置主窗口的根视图
        let contentView = MYKContentView()
        window?.rootViewController = UIHostingController(rootView: contentView)
        
        // 设置主窗口为最高层级并显示
        window?.windowLevel = .normal
        window?.makeKeyAndVisible()
    }
        
    private func removeLaunchScreen() {
        UIView.animate(withDuration: 0.3, animations: {
            self.launchWindow?.alpha = 0
        }) { _ in
            self.launchWindow = nil
            
            // 初始化主窗口
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            // 设置主窗口的根视图
            let contentView = MYKContentView()
            self.window?.rootViewController = UIHostingController(rootView: contentView)
            
            // 设置主窗口为最高层级并显示
            self.window?.windowLevel = .normal
            self.window?.makeKeyAndVisible()
            
            // 调试信息
            print("Main window created: \(self.window != nil)")
            print("Main window is hidden: \(self.window?.isHidden ?? true)")
        }
    }
}
