import SwiftUI

struct FPSBallView: View {
    @State private var fps: Int = 0
    @State private var isExpanded: Bool = false
    @State private var offset: CGSize = .zero
    
    var body: some View {
        VStack {
            if isExpanded {
                Text("FPS: \(fps)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                    .transition(.opacity)
            }
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
//                print("fpsBallWindow is hidden: \(fpsBallWindow?.isHidden ?? true)")
            }) {
                Image(systemName: isExpanded ? "xmark.circle.fill" : "circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding(8)
        .background(Color.black.opacity(0.5))
        .cornerRadius(isExpanded ? 12 : 24)
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { gesture in
                    withAnimation {
                        offset = .zero
                    }
                }
        )
        .onAppear {
            FPSCounter.shared.onFPSUpdate = { newFPS in
                fps = newFPS
            }
//            print("fpsBallWindow created: \(fpsBallWindow != nil)")

        }
    }
} 
