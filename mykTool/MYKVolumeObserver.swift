//
//  MYKVolumeObserver.swift
//  没眼看工具
//
//  Created by 薛 on 2025/1/4.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

class MYKVolumeObserver: NSObject, ObservableObject {
    @Published var volume: Float = 0.0
    
    override init() {
        super.init()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            audioSession.addObserver(self, forKeyPath: "outputVolume", options: [.new], context: nil)
        } catch {
            print("Failed to observe system volume")
        }
    }

    deinit {
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "outputVolume" else { return }
        guard let newVolume = change?[.newKey] as? Float else { return }
        DispatchQueue.main.async {
            self.volume = newVolume
        }
    }
}
