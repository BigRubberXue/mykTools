import SwiftUI

struct CoverView: View {
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.1))
            .frame(width: 250, height: 250)
            .overlay(
                Image(systemName: "music.note")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            )
    }
}

struct TitleView: View {
    let file: MYKFile?
    
    var body: some View {
        VStack(spacing: 8) {
            Text(file?.title ?? "未选择音频")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(file?.originalString ?? "请选择文件夹")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct PlayerControlView: View {
    @ObservedObject var playerManager: MYKMusicPlayerManager
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    @State private var progress: Double = 0
    @State private var currentTime: TimeInterval = 0
    @State private var duration: TimeInterval = 0
    
    var body: some View {
        VStack(spacing: 20) {
            MYKProgressView(
                progress: $progress,
                currentTime: $currentTime,
                duration: $duration,
                playerManager: playerManager
            )
            .padding(.horizontal, 20)
            
            HStack(spacing: 40) {
                Button(action: onPrevious) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                }
                
                MYKPlayPauseButton(playerManager: playerManager)
                
                Button(action: onNext) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                }
            }
            .foregroundColor(.blue)
        }
        .onAppear {
            setupCallbacks()
        }
    }
    
    private func setupCallbacks() {
        playerManager.onTimeUpdate = { self.currentTime = $0 }
        playerManager.onDurationUpdate = { self.duration = $0 }
        playerManager.onProgressChanged = { self.progress = $0 }
    }
} 
