//
//  SceneDelegate.swift
//  mykTools
//
//  Created by 薛 on 2025/1/13.
//

import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?
    private var launchWindow: UIWindow?
    private var fpsBallWindow: UIWindow?

    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        // 场景更新时的处理
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // 场景即将进入非活动状态时保存数据
        MYKAppDataManager.shared.saveData()
        MYKAppDataManager.shared.saveMusicFolder()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // 场景断开连接时保存数据
        MYKAppDataManager.shared.saveData()
        MYKAppDataManager.shared.saveMusicFolder()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 调试信息
        guard let windowScene = (scene as? UIWindowScene) else { return }
        print("SceneDelegate: windowScene connected")
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: MYKContentView())
//        window?.makeKeyAndVisible()
        
        MYKSplashManager.shared.tryStartSplashWindow(scene, mainWindow: window)
//
//        window = UIWindow(windowScene: windowScene)
//        
//        // 确保使用 windowScene 来设置 window 的 frame
//        window?.frame = windowScene.coordinateSpace.bounds
//        
//        window?.rootViewController = UIHostingController(rootView: MYKContentView())
//        window?.makeKeyAndVisible()
        
        // 1. 创建并显示启动窗口
//        showLaunchScreen()
//        
//        // 2. 延迟3秒后切换到主窗口
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.showMainWindow()
//            self.removeLaunchScreen()
//        }
//        
        return
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
