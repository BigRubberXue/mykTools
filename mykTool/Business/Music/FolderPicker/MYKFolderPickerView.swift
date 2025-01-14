import SwiftUI

struct MYKFolderPickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var dataManager = MYKAppDataManager.shared
    @Binding var selectedFolder: MYKMusicFolder?
    
    @State private var expandedFolderId: UUID?
    @State private var tempMusicFolder: MYKMusicFolder?
    @State private var showingAddFolderAlert = false
    @State private var newFolderName = ""
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @State private var selectedFile: MYKFile?
    @State private var showingFileDetail = false
    
    @StateObject private var playerManager = MYKMusicPlayerManager()
    @State private var playingFile: MYKFile?
    
    @State private var showingAddFileView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(dataManager.getAllFolders().enumerated()), id: \.element.id) { index, folder in
                    folderSection(folder, at: index)
                }
            }
            .navigationBarTitle("选择文件夹", displayMode: .inline)
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: HStack {
                    if tempMusicFolder != nil {
                        addFileButton
                    }
                    addFolderButton
                    confirmButton
                }
            )
            .alert("新建文件夹", isPresented: $showingAddFolderAlert) {
                TextField("文件夹名称", text: $newFolderName)
                Button("取消", role: .cancel) { newFolderName = "" }
                Button("创建", action: createNewFolder)
            }
            .alert("创建失败", isPresented: $showingErrorAlert) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $showingAddFileView) {
                if let folder = tempMusicFolder,
                   let folderIndex = folder.indexNum {
                    MYKAddFileView(folderIndex: folderIndex)
                }
            }
            .sheet(item: $selectedFile) { file in
                NavigationView {
                    MYKFileDetailView(
                        folderIndex: tempMusicFolder?.indexNum ?? 0, file: file
                    )
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            tempMusicFolder = selectedFolder
        }
    }
    
    // MARK: - Subviews
    private func folderSection(_ folder: MYKMusicFolder, at index: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            folderHeader(folder, at: index)
            
            if expandedFolderId == folder.id {
                filesList(folder, folderIndex: index)
            }
        }
    }
    
    private func folderHeader(_ folder: MYKMusicFolder, at index: Int) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(folder.name)
                    .font(.headline)
                Text("\(folder.files.count) 个文件")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            expandButton(folder, at: index)
            selectButton(folder, at: index)
        }
        .padding(.vertical, 4)
    }
    
    private func filesList(_ folder: MYKMusicFolder, folderIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(folder.files.enumerated()), id: \.element.id) { index, file in
//                var fileWithIndex = file
//                fileWithIndex.updateIndexNum(index)
                fileRow(file, folderIndex: folderIndex)
                
                if index != folder.files.count - 1 {
                    Divider().padding(.leading)
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.leading)
    }
    
    private var addFolderButton: some View {
        Button(action: {
            showingAddFolderAlert = true
        }) {
            Image(systemName: "folder.badge.plus")
                .foregroundColor(.blue)
        }
    }
    
    private var confirmButton: some View {
        Button("确定") {
            if let folder = tempMusicFolder {
                selectedFolder = folder
            }
            presentationMode.wrappedValue.dismiss()
        }
        .disabled(tempMusicFolder == nil)
    }
    
    private func expandButton(_ folder: MYKMusicFolder, at index: Int) -> some View {
        Button(action: {
            withAnimation {
                if expandedFolderId == folder.id {
                    expandedFolderId = nil
                } else {
                    expandedFolderId = folder.id
                }
            }
        }) {
            Image(systemName: expandedFolderId == folder.id ? "chevron.up" : "chevron.down")
                .foregroundColor(.blue)
        }
    }
    
    private func selectButton(_ folder: MYKMusicFolder, at index: Int) -> some View {
        Button(action: {
            var updatedFolder = folder
            updatedFolder.updateIndexNum(index)
            tempMusicFolder = updatedFolder
        }) {
            Image(systemName: tempMusicFolder?.id == folder.id ? "checkmark.circle.fill" : "circle")
                .foregroundColor(.blue)
        }
    }
    
    private func fileRow(_ file: MYKFile, folderIndex: Int) -> some View {
        HStack {
            Button(action: {
                selectedFile = file
            }) {
                VStack(alignment: .leading) {
                    Text(file.title.isEmpty ? "未命名" : file.title)
                        .font(.subheadline)
                    Text(file.originalString)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Button(action: {
                if playingFile?.id == file.id {
                    if playerManager.isPlaying {
                        playerManager.pause()
                    } else {
                        playerManager.play()
                    }
                } else {
                    playerManager.loadFile(file)
                    playerManager.play()
                    playingFile = file
                }
            }) {
                Image(systemName: getPlayButtonIcon(for: file))
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding(.leading, 8)
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.white)
    }
    
    private func getPlayButtonIcon(for file: MYKFile) -> String {
        if file.id == playingFile?.id {
            return playerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill"
        }
        return "play.circle"
    }
    
    private var addFileButton: some View {
        Button(action: {
            showingAddFileView = true
        }) {
            Image(systemName: "doc.badge.plus")
                .foregroundColor(.blue)
        }
    }
    
    // MARK: - Private Methods
    private func createNewFolder() {
        let result = dataManager.createFolder(newFolderName)
        if !result.success {
            errorMessage = result.message
            showingErrorAlert = true
        }
        newFolderName = ""
    }
}
