import UIKit

class FPSCounter: NSObject {
    static let shared = FPSCounter()
    
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var frameCount: Int = 0
    private var currentFPS: Int = 0
    
    var onFPSUpdate: ((Int) -> Void)?
    
    private override init() {
        super.init()
        start()
    }
    
    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateFrame(displayLink: CADisplayLink) {
        let currentTimestamp = displayLink.timestamp
        if lastTimestamp == 0 {
            lastTimestamp = currentTimestamp
            return
        }
        
        frameCount += 1
        let delta = currentTimestamp - lastTimestamp
        
        if delta >= 1.0 {
            currentFPS = Int(round(Double(frameCount) / delta))
            frameCount = 0
            lastTimestamp = currentTimestamp
            
            DispatchQueue.main.async {
                self.onFPSUpdate?(self.currentFPS)
            }
        }
    }
} 