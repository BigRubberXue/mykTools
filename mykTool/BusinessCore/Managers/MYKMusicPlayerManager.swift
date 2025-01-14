import Foundation
import AVFoundation

class MYKMusicPlayerManager: ObservableObject {
    @Published var folders: [MYKMusicFolder] = []
    @Published var currentTrack: MusicTrack?
    private var player: AVPlayer?
    private var timeObserver: Any?

    @Published var isPlaying = false
    @Published var progress: Double = 0
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var hasValidFile = false  // 新增：标记是否有有效文件
    
    // 添加时间更新回调
    var onTimeUpdate: ((TimeInterval) -> Void)?
    // 添加播放状态更新回调
    var onPlayStateChanged: ((Bool) -> Void)?
    var onProgressChanged: ((Double) -> Void)?
    var onDurationUpdate: ((TimeInterval) -> Void)?
    var onPlaybackFinished: (() -> Void)?
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    func loadAudio(from string: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: string) else {
            completion(false)
            return
        }
        
        // 重置当前播放器状态
        resetPlayerState()
        
        // 设置新的播放器
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // 观察播放器状态
        player?.currentItem?.asset.loadValuesAsynchronously(forKeys: ["playable"]) { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                var error: NSError?
                let status = self.player?.currentItem?.asset.statusOfValue(forKey: "playable", error: &error)
                
                if status == .loaded {
                    self.hasValidFile = true
                    self.setupTimeObserver()
                    self.duration = self.player?.currentItem?.duration.seconds ?? 0
                    completion(true)
                } else {
                    self.hasValidFile = false
                    completion(false)
                }
            }
        }
    }
    
    func play() {
        guard hasValidFile else { return }
        player?.play()
        isPlaying = true
        onPlayStateChanged?(true)  // 通知播放状态改变
    }
    
    func pause() {
        guard hasValidFile else { return }
        player?.pause()
        isPlaying = false
        onPlayStateChanged?(false)  // 通知播放状态改变
    }
    
    func stop() {
        resetPlayerState()
    }
    
    func invalidate() {
        resetPlayerState()
    }
    
    func setupPlayer(with url: URL?) {
        guard let url = url else {
            hasValidFile = false
            resetPlayerState()
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        hasValidFile = true
        setupTimeObserver()
    }
    
    private func resetPlayerState() {
        player?.pause()
        player = nil
        isPlaying = false
        progress = 0
        currentTime = 0
        duration = 0
        onPlayStateChanged?(false)
        onProgressChanged?(0)
        onTimeUpdate = nil  // 重置回调
        
        // 移除旧的观察者
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    func togglePlayPause() {
        guard hasValidFile else { return }
        
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
    
    func next() {
        guard hasValidFile else { return }
        // 实现下一首逻辑
    }
    
    func previous() {
        guard hasValidFile else { return }
        // 实现上一首逻辑
    }
    
    private func setupTimeObserver() {
        // 移除旧的观察者
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        
        // 添加新的观察者
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let duration = self?.player?.currentItem?.duration.seconds,
                  duration > 0 else { return }
            
            self?.currentTime = time.seconds
            self?.duration = duration
            let progress = time.seconds / duration
            self?.progress = progress
            
            // 调用回调
            self?.onTimeUpdate?(time.seconds)
            self?.onProgressChanged?(progress)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        resetPlayerState()
    }
    
    func seek(to time: TimeInterval) {
        guard hasValidFile,
              let player = player else { return }
        
        // 创建 CMTime 对象
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        
        // 执行跳转
        player.seek(to: cmTime) { [weak self] finished in
            if finished {
                // 更新当前时间
                self?.currentTime = time
                // 更新进度
                if let duration = self?.duration, duration > 0 {
                    self?.progress = time / duration
                }
                // 调用时间更新回调
                self?.onTimeUpdate?(time)
            }
        }
    }
    
    // 添加一个便利方法，接受百分比作为参数
    func seekToPercent(_ percent: Double) {
        guard hasValidFile,
              duration > 0 else { return }
        
        let targetTime = duration * percent
        seek(to: targetTime)
    }
    
    func loadFile(_ file: MYKFile) {
        // 重置当前播放器状态
        resetPlayerState()
        
        // 从 keyName 构建文件 URL
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get documents directory")
            return
        }
        
        let fileURL = documentsPath.appendingPathComponent("mytools/music/\(file.keyName)")
        
        // 检查文件是否存在
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("Audio file not found at path: \(fileURL.path)")
            hasValidFile = false
            return
        }
        
        // 设置新的播放器
        let playerItem = AVPlayerItem(url: fileURL)
        player = AVPlayer(playerItem: playerItem)
        
        // 观察播放器状态
        player?.currentItem?.asset.loadValuesAsynchronously(forKeys: ["playable"]) { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                var error: NSError?
                let status = self.player?.currentItem?.asset.statusOfValue(forKey: "playable", error: &error)
                
                if status == .loaded {
                    self.hasValidFile = true
                    self.setupTimeObserver()
                    if let duration = self.player?.currentItem?.duration.seconds {
                        self.duration = duration
                        self.onDurationUpdate?(duration)
                    }
                    
                    // 添加播放完成的通知
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(self.playerDidFinishPlaying),
                        name: .AVPlayerItemDidPlayToEndTime,
                        object: self.player?.currentItem
                    )
                    
                } else {
                    self.hasValidFile = false
                    print("Failed to load audio file: \(error?.localizedDescription ?? "unknown error")")
                }
            }
        }
    }
    
    // 添加播放完成的处理方法
    @objc private func playerDidFinishPlaying() {
        DispatchQueue.main.async { [weak self] in
            self?.isPlaying = false
            self?.onPlayStateChanged?(false)
            self?.onPlaybackFinished?()
        }
    }
}
