import SwiftUI
import SDWebImageSwiftUI

struct MYKAddFileView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = MYKAppDataManager.shared
    
    let folderIndex: Int
    
    @State private var newFileTitle = ""
    @State private var newFileVideoURL = ""
    @State private var newFileProcessedURL = ""
    @State private var newFileDuration = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("标题", text: $newFileTitle)
                    TextField("视频地址", text: $newFileVideoURL)
                }
                
                Section(header: Text("附加信息")) {
                    TextField("处理后链接", text: $newFileProcessedURL)
                    TextField("时长(秒)", text: $newFileDuration)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle("添加文件", displayMode: .inline)
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    saveFile()
                }
            )
            .alert("错误", isPresented: $showingError) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveFile() {
        Task {
            do {
                // 获取视频信息
                let videoInfo = try await MYKNetworkManager.shared.getVideoInfo(url: newFileVideoURL)
                
                // 创建新文件
                let newFile = MYKFile(
                    originalString: newFileVideoURL,
                    processedString: videoInfo.url,
                    keyName: UUID().uuidString,
                    title: newFileTitle.isEmpty ? videoInfo.title : newFileTitle,
                    duration: videoInfo.duration
                )
                
                // 添加文件到文件夹
                dataManager.addFile(newFile, to: folderIndex)
                
                // 关闭页面
                presentationMode.wrappedValue.dismiss()
            } catch {
                showError(error.localizedDescription)
            }
        }
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
} 
