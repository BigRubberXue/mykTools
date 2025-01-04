//
//  MYKDetailRow.swift
//  没眼看工具
//
//  Created by 薛 on 2025/1/6.
//

import Foundation
import SwiftUI
// 详情行组件
struct MYKDetailRow: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(content)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true) // 允许文本完整显示
        }
    }
}
