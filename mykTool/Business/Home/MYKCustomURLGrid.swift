//
//  MYKCustomURLGrid.swift
//  mykTools
//
//  Created by 薛 on 2025/1/15.
//

import SwiftUI

struct MYKCustomURLGrid: View {
    @EnvironmentObject private var dataManager: MYKAppDataManager
    @State private var showingDeleteAlert = false
    @State private var urlToDelete: MYKCustomURL?
    @State private var isEditing = false
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(dataManager.customURLs) { customURL in
                MYKCustomURLButton(url: customURL, isEditing: isEditing) {
                    urlToDelete = customURL
                    showingDeleteAlert = true
                }
            }
        }
        .padding(.horizontal)
        .alert("确认删除", isPresented: $showingDeleteAlert, presenting: urlToDelete) { url in
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                if let index = dataManager.customURLs.firstIndex(where: { $0.id == url.id }) {
                    dataManager.customURLs.remove(at: index)
                }
            }
        } message: { url in
            Text("确定要删除`\(url.name)`吗？")
        }
    }
}
    
