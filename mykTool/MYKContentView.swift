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
//import MYKVolumeObserver

extension Color {
    static let customBackground = Color(red: 255/255, green: 253/255, blue: 240/255)
    static let customButton = Color(red: 255/255, green: 248/255, blue: 220/255)
    static let customControl = Color(red: 255/255, green: 254/255, blue: 245/255)
}

struct CustomURLView: View {
    @EnvironmentObject private var dataManager: MYKAppDataManager
    @State private var showingAddSheet = false
    @State private var showingDeleteAlert = false
    @State private var urlToDelete: CustomURL?
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
                                VStack {
                                    Image(systemName: "link")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                    Text(customURL.name)
                                        .font(.headline)
                                        .foregroundColor(.gray)
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

struct CustomURL: Identifiable, Codable {
    var id = UUID()
    var name: String
    var urlString: String
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
                    let newURL = CustomURL(name: name, urlString: urlString)
                    dataManager.addCustomURL(newURL)
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
            SystemFeaturesView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("系统功能")
                }
            
            CustomURLView()
                .tabItem {
                    Image(systemName: "link")
                    Text("自定义功能")
                }
        }
    }
}

struct SystemFeaturesView: View {
    @State private var brightness: CGFloat = UIScreen.main.brightness
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 现有的按钮网格
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        SystemFeatureButton(
                            title: "打开快捷指令",
                            icon: "command",
                            urlString: "shortcuts://"
                        )
                        
                        SystemFeatureButton(
                            title: "打开相机",
                            icon: "camera",
                            urlString: "camera://"
                        )
                        
                        SystemFeatureButton(
                            title: "打开备忘录",
                            icon: "note.text",
                            urlString: "mobilenotes://"
                        )
                        
                        SystemFeatureButton(
                            title: "打开提醒事项",
                            icon: "list.bullet",
                            urlString: "reminders://"
                        )
                        
                        SystemFeatureButton(
                            title: "打开照片",
                            icon: "photo",
                            urlString: "photos-redirect://"
                        )
                    }
                    .padding()
                    
                    // 设备控制部分
                    VStack(spacing: 16) {
                        // 音量控制
                        DeviceControlSlider(
                            value: .constant(0),
                            icon: "speaker.wave.3.fill",
                            title: "音量"
                        )
                        .disabled(true) // 禁用交互
                        .opacity(0.5) // 降低透明度表示禁用状态
                        
                        // 亮度控制
                        DeviceControlSlider(
                            value: Binding(
                                get: { Float(brightness) },
                                set: { newValue in
                                    brightness = CGFloat(newValue)
                                    UIScreen.main.brightness = brightness
                                }
                            ),
                            icon: "sun.max.fill",
                            title: "亮度"
                        )
                    }
                    .padding()
                    .background(Color.customControl)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                    )
                    .padding(.horizontal)
                    
                    // 添加横幅图片
                    Image("myk-bunny-banner")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .cornerRadius(15)
                }
            }
            .background(Color.customBackground)
            .navigationTitle("系统工具")
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
extension CustomURLView {
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



