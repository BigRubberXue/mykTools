import UIKit
import SwiftUI

//@UIApplicationMain
//@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 1. 创建并显示启动窗口
//        showLaunchScreen()
//        MYKSplashManager.shared.tryStartSplashWindow()
//
//        // 2. 延迟3秒后切换到主窗口
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.showMainWindow()
//            self.removeLaunchScreen()
//        }
        if #available(iOS 13, *) {
            return true
        }
        // 初始化主 window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: MYKContentView()) // 替换为你的根视图
        print("Main window created: \(window != nil)")
        print("Main window is hidden: \(window?.isHidden ?? true)")
        MYKSplashManager.shared.tryStartSplashWindow(application, mainWindow: window)

        // 添加悬浮球
//        addFPSBall()
        
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

    
}
