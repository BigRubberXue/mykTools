//
//  mykToolApp.swift
//  mykTool
//
//  Created by 薛 on 2025/1/3.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        // 场景更新时的处理
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // 场景即将进入非活动状态时保存数据
        MYKAppDataManager.shared.saveData()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // 场景断开连接时保存数据
        MYKAppDataManager.shared.saveData()
    }
}

@main
struct mykToolApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var dataManager = MYKAppDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environmentObject(dataManager)
        }
    }
}
