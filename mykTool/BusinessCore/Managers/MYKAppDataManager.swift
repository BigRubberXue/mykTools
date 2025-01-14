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
    
    // 已有的自定义 URL 数据
    @Published private(set) var musicFolders: [MYKMusicFolder] = []
    @Published var customURLs: [MYKCustomURL] = []
    // 新增文件夹数据
    // @Published var musicFolders: [MYKMusicFolder] = []
    
    // 文件管理器
    private let fileManager = FileManager.default
    
    // Documents 目录URL
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // 数据文件路径
    private var foldersFileURL: URL {
        // 1. 确保目录存在
        let directoryURL = documentsDirectory.appendingPathComponent("mytools/music")
        try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        return directoryURL.appendingPathComponent("myk_folders.json")
    }
    
    // 私有初始化方法，确保只能通过 shared 访问
    private init() {
        // 初始化时从本地存储加载数据
        loadURLData()
        // 初始化音乐播放器列表
        loadMusciFolder()
    }
    
    // MARK: - url数据加载和保存
    private func loadURLData() {
        // 加载已有的 MYKCustomURL
        customURLs = UserDefaults.standard.getCustomURLs()
    }
    
    func saveData() {
        // 保存已有的 CustomURLs
        UserDefaults.standard.setCustomURLs(customURLs)
    }
    
    func addCustomURL(customUrl: MYKCustomURL) {
        customURLs.append(customUrl)
    }
    
    // MARK: - 文件夹操作
    func loadMusciFolder() {
        // 从 Documents 加载文件夹数据
        do {
            // 添加日志
            print("Attempting to load folders from: \(foldersFileURL.path)")
            
            if fileManager.fileExists(atPath: foldersFileURL.path) {
                let data = try Data(contentsOf: foldersFileURL)
                print("Data loaded, size: \(data.count) bytes")
                
                musicFolders = try JSONDecoder().decode([MYKMusicFolder].self, from: data)
                print("Successfully loaded \(musicFolders.count) folders")
            } else {
                print("No folders file found at path")
                musicFolders = []
            }
        } catch {
            print("Error loading folders data: \(error)")
            musicFolders = []
        }
//        print("musicFolders = %@", musicFolders);
    }
    
    func saveMusicFolder() {
        // 保存文件夹数据到 Documents
        do {
            // 3. 确保目录存在
            let directoryURL = documentsDirectory.appendingPathComponent("mytools/music")
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            
            // 4. 添加日志
            print("Attempting to save \(musicFolders.count) folders to: \(foldersFileURL.path)")
            
            let data = try JSONEncoder().encode(musicFolders)
            try data.write(to: foldersFileURL)
            
            print("Successfully saved folders data")
        } catch {
            print("Error saving folders data: \(error)")
        }
    }
    
    func addFolder(_ name: String) {
        let newFolder = MYKMusicFolder(name: name)
        musicFolders.append(newFolder)
    }
    
    func removeFolder(at index: Int) {
        musicFolders.remove(at: index)
    }
    
    func removeFolder(folder: MYKMusicFolder) {
        musicFolders.removeAll(where: {$0 == folder})
    }
    
    func updateFolder(_ folder: MYKMusicFolder) {
        guard let index = musicFolders.firstIndex(where: { $0 == folder }) else { return }
        guard index < musicFolders.count else { return }
        musicFolders[index] = folder
    }
    
    // MARK: - 文件操作
//    func addFile(originalString: String, processedString: String, to folderIndex: Int) {
//        guard folderIndex < musicFolders.count else { return }
//        let newFile = MYKFile(
//            id: UUID(),
//            originalString: originalString,
//            processedString: processedString,
//            createDate: Date(),
//            keyName: ""
//        )
//        musicFolders[folderIndex].files.append(newFile)
//        saveMusicFolder()
//    }
    
    func addFile(_ file: MYKFile, to folderIndex: Int) {
        guard folderIndex >= 0, folderIndex < musicFolders.count else { return }
        
        // 使用第一个文件夹（默认文件夹）
        let folderIndex = 0
        
        // 检查文件是否已存在（通过 keyName 判断）
        let isFileExists = musicFolders[folderIndex].files.contains { $0.keyName == file.keyName }
        if isFileExists {
            print("File already exists with keyName: `\(file.keyName)`")
            return
        }
        let indexNum = musicFolders[folderIndex].files.count
        // 添加文件到文件夹
        var mutableFileItem = file
        mutableFileItem.updateIndexNum(indexNum)
        musicFolders[folderIndex].files.append(mutableFileItem)
        
        // 保存更新后的数据
//        saveMusicFolder()
    }
    
    func removeFile(at fileIndex: Int, from folderIndex: Int) {
        guard folderIndex < musicFolders.count else { return }
        musicFolders[folderIndex].files.remove(at: fileIndex)
//        saveMusicFolder()
    }
    
    func updateFile(_ file: MYKFile, at fileIndex: Int, in folderIndex: Int) {
        guard folderIndex < musicFolders.count,
              fileIndex < musicFolders[folderIndex].files.count else { return }
        musicFolders[folderIndex].files[fileIndex] = file
        saveMusicFolder()
    }
    
    // MARK: - 错误处理
    enum StorageError: Error {
        case saveError(String)
        case loadError(String)
    }
    
    func createFolder(_ name: String) -> (success: Bool, message: String) {
        // 检查名称是否为空
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return (false, "文件夹名称不能为空")
        }
        
        // 检查名称是否重复
        if musicFolders.contains(where: { $0.name == name }) {
            return (false, "创建失败，名称已存在")
        }
        
        // 创建新文件夹
        let newFolder = MYKMusicFolder(name: name)
        musicFolders.append(newFolder)
//        saveMusicFolder()  // 保存到本地存储
        
        return (true, "创建成功")
    }
    
    // MARK: - Public Methods
    
    // 获取所有文件夹
    func getAllFolders() -> [MYKMusicFolder] {
        return musicFolders
    }
    
    // 获取指定索引的文件夹
    func getFolder(at index: Int) -> MYKMusicFolder? {
        guard index >= 0, index < musicFolders.count else { return nil }
        return musicFolders[index]
    }
}

extension UserDefaults {
    func setCustomURLs(_ urls: [MYKCustomURL]) {
        if let encoded = try? JSONEncoder().encode(urls) {
            UserDefaults.standard.set(encoded, forKey: "myk_link_savedCustomURLs")
        }
    }
    
    func getCustomURLs() -> [MYKCustomURL] {
        if let data = UserDefaults.standard.data(forKey: "myk_link_savedCustomURLs"),
           let decoded = try? JSONDecoder().decode([MYKCustomURL].self, from: data) {
            return decoded
        }
        return []
    }
}
