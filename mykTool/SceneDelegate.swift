//
//  SceneDelegate.swift
//  mykTools
//
//  Created by 薛 on 2025/1/13.
//

import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?

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
//        window = UIWindow(windowScene: windowScene)
//        window?.rootViewController = UIHostingController(rootView: MYKContentView())
//        window?.makeKeyAndVisible()
//        
        
        
        window = UIWindow(windowScene: windowScene)
        
        // 确保使用 windowScene 来设置 window 的 frame
        window?.frame = windowScene.coordinateSpace.bounds
        
        window?.rootViewController = UIHostingController(rootView: MYKContentView())
        window?.makeKeyAndVisible()
        
        return
    }
    
    
    
}
