import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var countdown = 5
    @State private var myTimer: Timer?
    
    // 定义启动屏背景色 #EADEC5
    private let launchScreenBackground = Color(
        red: 234/255,
        green: 222/255,
        blue: 197/255
    )
    
    var body: some View {
        ZStack {
            // 全屏背景色
            launchScreenBackground.ignoresSafeArea()
            
            // 居中的内容
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Image("myk-launch-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        
                    Text("开屏页面")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .scaleEffect(size)
                .opacity(opacity)
                    
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            // 右上角倒计时胶囊
            VStack {
                HStack {
                    Spacer()
                    ZStack(alignment: .topTrailing) {
                        Color
                            .black.opacity(0.7)
                            .frame(width: 80, height: 40)
                            .clipShape(Capsule())
                            .padding(.trailing, 20)
                        Button("\(countdown)s 跳过", action: {
//                            print("LaunchScreenView - click");
                            finishSplash()
                        })
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .frame(alignment: .trailing)
                        .padding(.trailing, 30)
                        .padding(.top, 10)
                        .buttonStyle(PlainButtonStyle()) // 去掉点击效果
                    }
                }
                Spacer()
            }
        }            
        .onAppear {
            startCountdown()
        }
    }

    private func startCountdown() {
        self.myTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.countdown > 0 {
                self.countdown -= 1
            } else {
                timer.invalidate()
                print("Countdown finished")
                self.isActive = true
                MYKSplashManager.shared.removeLaunchScreen(completion: nil)
            }
        }
    }
    
    private func finishSplash() {
        self.myTimer?.invalidate()
        print("click skip finished")
        self.isActive = true
        MYKSplashManager.shared.removeLaunchScreen(completion: nil)
    }
}

#Preview {
    LaunchScreenView()
} 
