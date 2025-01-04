import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
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
                        
                    Text("没眼看工具")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .scaleEffect(size)
                .opacity(opacity)
                    
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
        }            
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isActive = true
            }
        }
    }
}

#Preview {
    LaunchScreenView()
} 
