import SwiftUI
import AVFoundation

struct MYKMusicPlayerView: View {
    @StateObject private var playerManager = MYKMusicPlayerManager()
    @StateObject private var dataManager = MYKAppDataManager.shared
    @State private var showFolderPicker = false
    @State private var selectedFolder: MYKMusicFolder?
    @State private var playList: [MYKFile] = []
    @State private var currentIndex: Int = 0
    
    private var currentFile: MYKFile? {
        guard !playList.isEmpty, currentIndex < playList.count else { return nil }
        return playList[currentIndex]
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                MYKCoverView()
                    .padding(.top, 40)
                    .opacity(currentFile == nil ? 0.5 : 1.0)
                
                MYKTitleView(
                    title: currentFile?.title ?? "未选择音频",
                    subtitle: currentFile?.originalString ?? "请选择文件夹"
                )
                
                // 播放控制区域
                VStack(spacing: 20) {
                    MYKProgressView(
                        progress: .constant(playerManager.progress),
                        currentTime: .constant(playerManager.currentTime),
                        duration: .constant(playerManager.duration),
                        playerManager: playerManager
                    )
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 40) {
                        MYKControlButton(
                            systemName: "backward.fill",
                            action: playPrevious
                        )
                        .disabled(currentFile == nil)
                        
                        MYKPlayPauseButton(playerManager: playerManager)
                            .disabled(currentFile == nil)
                        
                        MYKControlButton(
                            systemName: "forward.fill",
                            action: playNext
                        )
                        .disabled(currentFile == nil)
                    }
                    .opacity(currentFile == nil ? 0.5 : 1.0)
                }
                
                Spacer()
            }
            .navigationBarTitle("音乐播放器", displayMode: .inline)
            .navigationBarItems(trailing:
                MYKFolderPickerButton(showPicker: $showFolderPicker)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showFolderPicker) {
            MYKFolderPickerView(selectedFolder: $selectedFolder)
        }
        .onChange(of: selectedFolder) { folder in
            if let folder = folder {
                playList = folder.files
                if !playList.isEmpty {
                    currentIndex = 0
                    playCurrentFile()
                }
            }
        }
        .onAppear {
            playerManager.onPlaybackFinished = playNext
        }
    }
    
    // MARK: - Private Methods
    private func playPrevious() {
        guard !playList.isEmpty else { return }
        currentIndex = (currentIndex - 1 + playList.count) % playList.count
        playCurrentFile()
    }
    
    private func playNext() {
        guard !playList.isEmpty else { return }
        currentIndex = (currentIndex + 1) % playList.count
        playCurrentFile()
    }
    
    private func playCurrentFile() {
        if let file = currentFile {
            playerManager.loadFile(file)
            playerManager.play()
        }
    }
    
    private func updateCurrentFolder() {
        if let folder = selectedFolder,
           let index = folder.indexNum,
           let updatedFolder = dataManager.getFolder(at: index) {
            selectedFolder = updatedFolder
            playList = updatedFolder.files
        }
    }
}



