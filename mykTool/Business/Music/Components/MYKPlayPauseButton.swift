//
//  MYKPlayPauseButton.swift
//  没眼看工具
//
//  Created by 薛 on 2025/1/6.
//

import Foundation
import SwiftUI

struct MYKPlayPauseButton: View {
    @ObservedObject var playerManager: MYKMusicPlayerManager
    
    var body: some View {
        Button(action: togglePlay) {
            Image(systemName: playerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.system(size: 60))
        }
    }
    
    private func togglePlay() {
        if playerManager.isPlaying {
            playerManager.pause()
        } else {
            playerManager.play()
        }
    }
}
