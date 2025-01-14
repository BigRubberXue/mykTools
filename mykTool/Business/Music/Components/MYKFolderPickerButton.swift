//
//  MYKFolderPickerButton.swift
//  没眼看工具
//
//  Created by 薛 on 2025/1/6.
//

import Foundation
import SwiftUI

struct MYKFolderPickerButton: View {
    @Binding var showPicker: Bool
    
    var body: some View {
        Button(action: { showPicker = true }) {
            Image(systemName: "folder")
                .foregroundColor(.blue)
        }
    }
}
