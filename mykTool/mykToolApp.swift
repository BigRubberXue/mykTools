//
//  mykToolApp.swift
//  mykTool
//
//  Created by 薛 on 2025/1/3.
//

import SwiftUI

@main
struct mykToolApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataManager = MYKAppDataManager.shared
     var body: some Scene {
         WindowGroup {
             EmptyView()
         }
     }
    
    init() {
        print("App is starting...")
        // 在这里可以执行任何初始化逻辑
    }
    
}
