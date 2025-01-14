//
//  MYKContentView.swift
//  mykTool
//
//  Created by 薛 on 2025/1/3.
//

import SwiftUI
import MediaPlayer // 用于控制音量
import UIKit // 用于控制亮度
import AVFoundation

extension Color {
    static let customBackground = Color(red: 255/255, green: 253/255, blue: 240/255)
    static let customButton = Color(red: 255/255, green: 248/255, blue: 220/255)
    static let customControl = Color(red: 255/255, green: 254/255, blue: 245/255)
}

struct CustomURLView: View {
    @EnvironmentObject private var dataManager: MYKAppDataManager
    @State private var showingAddSheet = false
    @State private var showingDeleteAlert = false
    @State private var urlToDelete: MYKCustomURL?
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(dataManager.customURLs) { customURL in
                        ZStack(alignment: .topTrailing) {
                            Button(action: {
                                if !isEditing {
                                    openURL(customURL.urlString)
                                }
                            }) {
                                VStack(spacing: 12) {
                                    Image(systemName: "link")
                                        .font(.system(size: 30))
                                        .foregroundColor(.black)
                                    Text(customURL.name)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1, contentMode: .fill)
                                .padding()
                                .background(Color.customButton)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                                )
                                .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                            
                            // 删除按钮
                            if isEditing {
                                Button(action: {
                                    urlToDelete = customURL
                                    showingDeleteAlert = true
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 24))
                                }
                                .offset(x: 10, y: -10)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.customBackground)
            .navigationTitle("自定义功能")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            isEditing.toggle()
                        }
                    }) {
                        Text(isEditing ? "完成" : "编辑")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddCustomURLView()
            }
            .alert("确认删除", isPresented: $showingDeleteAlert, presenting: urlToDelete) { url in
                Button("取消", role: .cancel) { }
                Button("删除", role: .destructive) {
                    if let index = dataManager.customURLs.firstIndex(where: { $0.id == url.id }) {
                        withAnimation {
                            dataManager.customURLs.remove(at: index)
                        }
                    }
                }
            } message: { url in
                Text("确定要删除`\(url.name)`吗？")
            }
        }
    }
}



struct AddCustomURLView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var dataManager: MYKAppDataManager
    @State private var name = ""
    @State private var urlString = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("名称", text: $name)
                TextField("URL", text: $urlString)
            }
            .navigationTitle("添加自定义URL")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    let newURL = MYKCustomURL(name: name, urlString: urlString)
                    dataManager.addCustomURL(customUrl: newURL)
                    dismiss()
                }
                .disabled(name.isEmpty || urlString.isEmpty)
            )
        }
    }
}

struct MYKContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("主页")
                }
            
            MYKWebContainerView()
                .tabItem {
                    Image(systemName: "safari")
                    Text("浏览器")
                }
            
            MYKMusicPlayerView()
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("音乐")
                }
            
            MYKSettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("设置")
                }
        }.environmentObject(MYKAppDataManager.shared)
    }
}

// 主页视图
struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    SystemToolsSection()
                    CustomFeaturesSection()  // 移到设备控制上方
                    DeviceControlSection()
                    
                    // 添加底部横幅
                    Image("myk-bunny-banner")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                        .padding(.top, 20)
                }
                .padding(.vertical)
            }
            .background(Color.customBackground)
            .navigationTitle("工具箱")
        }
    }
}

// 系统工具区块
struct SystemToolsSection: View {
    private let systemTools = [
        ("打开快捷指令", "command", "shortcuts://"),
        ("打开相机", "camera", "camera://"),
        ("打开备忘录", "note.text", "mobilenotes://"),
        ("打开提醒事项", "list.bullet", "reminders://"),
        ("打开照片", "photo", "photos-redirect://")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("系统工具")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(systemTools, id: \.0) { title, icon, url in
                    SystemFeatureButton(title: title, icon: icon, urlString: url)
                }
            }
            .padding(.horizontal)
        }
    }
}

// 设备控制区块
struct DeviceControlSection: View {
    @StateObject private var volumeObserver = MYKVolumeObserver()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("设备控制")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                DeviceControlSlider(
                    value: $volumeObserver.volume,
                    icon: "speaker.wave.3.fill",
                    title: "音量"
                )
                
                DeviceControlSlider(
                    value: Binding(
                        get: { Float(UIScreen.main.brightness) },
                        set: { UIScreen.main.brightness = CGFloat($0) }
                    ),
                    icon: "sun.max.fill",
                    title: "亮度"
                )
            }
            .padding()
            .background(Color.customControl)
            .cornerRadius(15)
            .padding(.horizontal)
        }
    }
}

// 自定义功能区块
struct CustomFeaturesSection: View {
    @State private var showingAddSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("自定义功能")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showingAddSheet = true  // 显示添加sheet
                }) {
                    Image(systemName: "plus")
                }
            }
            .padding(.horizontal)
            
            CustomURLGrid()
        }
        .sheet(isPresented: $showingAddSheet) {
            AddCustomURLView()
        }
    }
}

// 自定义URL网格视图
struct CustomURLGrid: View {
//    @State private var dataManager: MYKAppDataManager = MYKAppDataManager.shared
    @EnvironmentObject private var dataManager: MYKAppDataManager
    @State private var showingDeleteAlert = false
    @State private var urlToDelete: MYKCustomURL?
    @State private var isEditing = false
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(dataManager.customURLs) { customURL in
                CustomURLButton(url: customURL, isEditing: isEditing) {
                    urlToDelete = customURL
                    showingDeleteAlert = true
                }
            }
        }
        .padding(.horizontal)
        .alert("确认删除", isPresented: $showingDeleteAlert, presenting: urlToDelete) { url in
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                if let index = dataManager.customURLs.firstIndex(where: { $0.id == url.id }) {
                    dataManager.customURLs.remove(at: index)
                }
            }
        } message: { url in
            Text("确定要删除`\(url.name)`吗？")
        }
    }
}

// 自定义URL按钮
struct CustomURLButton: View {
    let url: MYKCustomURL
    let isEditing: Bool
    let onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                if !isEditing {
                    openURL(url.urlString)
                }
            }) {
                VStack(spacing: 12) {
                    Image(systemName: "link")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                    Text(url.name)
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fill)
                .padding()
                .background(Color.customButton)
                .cornerRadius(15)
            }
            
            if isEditing {
                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 24))
                }
                .offset(x: 10, y: -10)
            }
        }
    }
}

struct SystemFeatureButton: View {
    let title: String
    let icon: String
    let urlString: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .padding()
            .background(Color.customButton)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
            )
            .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    MYKContentView()
}

func openURL(_ urlString: String) {
    if let url = URL(string: urlString),
       true {
        UIApplication.shared.open(url, options: [:]) { success in
            if !success {
                // URL failed to open, show alert
                let alert = UIAlertController(
                    title: "打开失败",
                    message: "请确认输入是否正确",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "确定", style: .default))
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let viewController = windowScene.windows.first?.rootViewController {
                    viewController.present(alert, animated: true)
                }
            }
        }
    } else {
        // Show alert when URL cannot be opened
        let alert = UIAlertController(
            title: "打开失败",
            message: "请确认输入是否正确",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alert, animated: true)
        }
    }
}

extension View {
    func customGridItemStyle() -> some View {
        self.frame(height: 150) // 增加每个选项的高度
    }
}

extension TabView {
    func customTabStyle() -> some View {
        self.safeAreaInset(edge: .bottom) { // 增加tab标题和选项的间距
            Color.clear.frame(height: 20)
        }
    }
}

// 添加音量控制扩展
extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            slider?.value = volume
        }
    }
}

// 设备控制滑块组件
struct DeviceControlSlider: View {
    @Binding var value: Float
    let icon: String
    let title: String
    var onChanged: ((Float) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.primary)
                Text(title)
                    .foregroundColor(.primary)
            }
            
            Slider(value: $value, in: 0...1) { _ in
                onChanged?(value)
            }
        }
    }
}



