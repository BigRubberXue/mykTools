//
//  MYKEditableDetailRow.swift
//  没眼看工具
//
//  Created by 薛 on 2025/1/6.
//

import Foundation
import SwiftUI


struct MYKEditableDetailRow: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextEditor(text: $text)
                .frame(minHeight: 44)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
}
