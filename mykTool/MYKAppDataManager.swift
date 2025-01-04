//
//  MYKAppDataManager.swift
//  mykTool
//
//  Created by 薛 on 2025/1/3.
//

import Foundation
import SwiftUI

class MYKAppDataManager: ObservableObject {
    // 单例实例
    static let shared = MYKAppDataManager()
    
    // 私有初始化方法，确保只能通过 shared 访问
    private init() {
        // 初始化时从本地存储加载数据
        loadData()
    }
    
    // 自定义 URL 数据
    @Published var customURLs: [CustomURL] = []
    
    // 从本地存储加载数据
    private func loadData() {
        customURLs = UserDefaults.standard.getCustomURLs()
    }
    
    // 保存数据到本地存储
    func saveData() {
        UserDefaults.standard.setCustomURLs(customURLs)
    }
    
    // 添加新的自定义 URL
    func addCustomURL(_ url: CustomURL) {
        customURLs.append(url)
    }
    
    // 删除自定义 URL
    func removeCustomURL(at index: Int) {
        customURLs.remove(at: index)
    }
    
    // 更新自定义 URL
    func updateCustomURL(_ url: CustomURL, at index: Int) {
        guard index < customURLs.count else { return }
        customURLs[index] = url
    }
}

extension UserDefaults {
    func setCustomURLs(_ urls: [CustomURL]) {
        if let encoded = try? JSONEncoder().encode(urls) {
            UserDefaults.standard.set(encoded, forKey: "myk_link_savedCustomURLs")
        }
    }
    
    func getCustomURLs() -> [CustomURL] {
        if let data = UserDefaults.standard.data(forKey: "myk_link_savedCustomURLs"),
           let decoded = try? JSONDecoder().decode([CustomURL].self, from: data) {
            return decoded
        }
        return []
    }
}
