//
//  MYKContentView.swift
//  mykTool
//
//  Created by 薛 on 2025/1/3.
//

import SwiftUI


struct MYKContentView: View {
//    @State private var selectedTab: Int = 0 // 跟踪当前选中的 Tab
    @State private var selectedTab: UUID = UUID() // 当前选中的 Tab

    var body: some View {
        let tabs = creatContentTabItems()
        MYKTabView(tabs: tabs, selectedTab: $selectedTab)
            .onAppear {
                // 默认选中第一个 Tab
                if let firstTab = tabs.first {
                    selectedTab = firstTab.id
                }
            }
            .environmentObject(MYKAppDataManager.shared)
    }
}

#Preview {
    MYKContentView()
}





