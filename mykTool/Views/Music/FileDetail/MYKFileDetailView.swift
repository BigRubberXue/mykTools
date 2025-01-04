import SwiftUI

struct MYKFileDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = MYKAppDataManager.shared
    let folderIndex: Int
    @State var file: MYKFile
    @State private var isEditing = false
    @State private var editedData = EditedData()
    @State private var showingSaveAlert = false
    @State private var showingDeleteAlert = false
    
    // 将编辑数据集中管理
    private struct EditedData {
        var title = ""
        var originalString = ""
        var processedString = ""
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    if isEditing {
                        editableContent
                    } else {
                        displayContent
                    }
                }
                .animation(.easeInOut, value: isEditing)
                
                deleteButton
            }
            .padding()
        }
        .navigationBarTitle("文件详情", displayMode: .inline)
        .navigationBarItems(trailing: 
            HStack {
                if isEditing {
                    saveButton
                }
                editButton
            }
        )
        .alert("确认保存", isPresented: $showingSaveAlert) {
            Button("取消", role: .cancel) { }
            Button("确定", action: saveChanges)
        } message: {
            Text("确定要保存修改吗？")
        }
        .alert("确认删除", isPresented: $showingDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                deleteFile()
            }
        } message: {
            Text("确定要删除这个文件吗？此操作不可恢复。")
        }
    }
    
    // MARK: - Subviews
    private var displayContent: some View {
        Group {
            MYKDetailRow(title: "标题", content: file.title.isEmpty ? "未命名" : file.title)
            MYKDetailRow(title: "原始链接", content: file.originalString)
            MYKDetailRow(title: "处理后链接", content: file.processedString)
            MYKDetailRow(title: "创建时间", content: formatDate(file.createDate))
            if let duration = file.duration {
                MYKDetailRow(title: "时长", content: formatDuration(duration))
            }
        }
    }
    
    private var editableContent: some View {
        Group {
            MYKEditableDetailRow(title: "标题", text: $editedData.title)
            MYKEditableDetailRow(title: "原始链接", text: $editedData.originalString)
            MYKEditableDetailRow(title: "处理后链接", text: $editedData.processedString)
            MYKDetailRow(title: "创建时间", content: formatDate(file.createDate))
            if let duration = file.duration {
                MYKDetailRow(title: "时长", content: formatDuration(duration))
            }
        }
    }
    
    private var editButton: some View {
        Button(isEditing ? "取消" : "编辑") {
            if isEditing {
                resetEditingData()
            } else {
                loadEditingData()
            }
            isEditing.toggle()
        }
    }
    
    private var saveButton: some View {
        Button("保存") {
            showingSaveAlert = true
        }
    }
    
    private var deleteButton: some View {
        Button(action: {
            showingDeleteAlert = true
        }) {
            HStack {
                Spacer()
                Text("删除文件")
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(Color.red)
            .cornerRadius(8)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Private Methods
    private func loadEditingData() {
        editedData = EditedData(
            title: file.title,
            originalString: file.originalString,
            processedString: file.processedString
        )
    }
    
    private func resetEditingData() {
        editedData = EditedData()
    }
    
    private func saveChanges() {
        var updatedFile = file
        updatedFile.title = editedData.title
        updatedFile.originalString = editedData.originalString
        updatedFile.processedString = editedData.processedString
        updatedFile.createDate = Date()
        
        dataManager.updateFile(updatedFile, at: file.indexNum ?? 0, in: folderIndex)
        isEditing = false
        resetEditingData()
    }
    
    private func deleteFile() {
        if let fileIndex = file.indexNum {
            dataManager.removeFile(at: fileIndex, from: folderIndex)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}




