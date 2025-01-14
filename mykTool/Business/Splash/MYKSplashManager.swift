//
//  MYKSplashManager.swift
//  mykTools
//
//  Created by 薛 on 2025/1/14.
//

import Foundation
import SwiftUI



class MYKSplashManager {
    // 单例模式，确保全局只有一个SplashManager实例
    static let shared = MYKSplashManager()
    private var launchWindow: UIWindow?
    private var lastWindow: UIWindow?
    
    func tryStartSplashWindow(_ application: UIApplication, mainWindow: UIWindow?) {
        if #available(iOS 13, *) {
            return;
        }
        // 创建启动窗口
        launchWindow = UIWindow(frame: UIScreen.main.bounds)
        // 设置启动窗口的根视图
        let launchView = LaunchScreenView()
        launchWindow?.rootViewController = UIHostingController(rootView: launchView)
        
        // 设置启动窗口为最高层级并显示
        launchWindow?.windowLevel = .alert + 1
        launchWindow?.makeKeyAndVisible()
        
        lastWindow = mainWindow
    }
    
    func tryStartSplashWindow(_ scene: UIScene, mainWindow: UIWindow?) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        launchWindow = UIWindow(windowScene: windowScene)
        // 设置启动窗口的根视图
        let launchView = LaunchScreenView()
        launchWindow?.rootViewController = UIHostingController(rootView: launchView)
        
        // 设置启动窗口为最高层级并显示
        launchWindow?.windowLevel = .alert + 1
        launchWindow?.makeKeyAndVisible()
        
        lastWindow = mainWindow
    }
    
    func removeLaunchScreen(completion: (() -> Void)?) {
        self.lastWindow?.makeKeyAndVisible()
        UIView.animate(withDuration: 0.3, animations: {
            self.launchWindow?.alpha = 0
        }) { _ in
            if let completion = completion {
                completion()
            }

        }
    }
}
