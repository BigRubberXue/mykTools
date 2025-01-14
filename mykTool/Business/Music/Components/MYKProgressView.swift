//
//  MYKProgressView.swift
//  没眼看工具
//
//  Created by 薛 on 2025/1/6.
//

import Foundation
import SwiftUI

struct MYKProgressView: View {
    @Binding var progress: Double
    @Binding var currentTime: TimeInterval
    @Binding var duration: TimeInterval
    @ObservedObject var playerManager: MYKMusicPlayerManager
    
    var body: some View {
        VStack(spacing: 8) {
            Slider(value: $progress, in: 0...1) { editing in
                if !editing {
                    playerManager.seekToPercent(progress)
                }
            }
            .disabled(!playerManager.hasValidFile)
            
            HStack {
                Text(formatTime(currentTime))
                Spacer()
                Text(formatTime(duration))
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

