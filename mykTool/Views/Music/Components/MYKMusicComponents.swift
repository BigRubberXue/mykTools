import SwiftUI

// 封面视图
struct MYKCoverView: View {
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

// 标题视图
struct MYKTitleView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// 控制按钮
struct MYKControlButton: View {
    let systemName: String
    let action: () -> Void
    var disabled: Bool = false  // 添加禁用状态属性
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(disabled ? .gray : .blue)  // 禁用时改变颜色
        }
        .disabled(disabled)  // 添加禁用状态
    }
} 