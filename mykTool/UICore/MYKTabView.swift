//
//  MYKTabView.swift
//  mykTools
//
//  Created by 薛 on 2025/1/15.
//

import Foundation
import SwiftUI

struct MYKTabView: View {
    let tabs: [MYKTabItem]
    @Binding var selectedTab: UUID
    @State private var cachedViews: [UUID: AnyView] = [:]
    
    var body: some View {
        VStack(spacing: 0) {
            // 显示当前选中的 Tab 内容
            if let selectedTabItem = tabs.first(where: { $0.id == selectedTab }) {
                showCachedViews(selectedTabItem: selectedTabItem)
                if selectedTabItem.canShowDivider {
                    Divider()
                }
            }
            
            // 自定义 TabBar
            MYKTabBar(tabs: tabs, selectedTab: $selectedTab)
        }
    }
    
    @ViewBuilder
    func showCachedViews(selectedTabItem: MYKTabItem) -> some View {
        if let cachedView = cachedViews[selectedTabItem.id] {
            cachedView // 显示缓存的视图
        } else {
            // 如果视图未缓存，加载并缓存
            selectedTabItem.content()
                .onAppear {
                    cachedViews[selectedTabItem.id] = AnyView(selectedTabItem.content())
                }
        }
    }
}

struct MYKTabBar: View {
    let tabs: [MYKTabItem]
    @Binding var selectedTab: UUID
    @State var tabBackgroundColor: Color = .white
    
    var body: some View {
        HStack {
            ForEach(tabs) { tab in
                Button(action: {
                    selectedTab = tab.id // 切换选中的 Tab
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20))
//                            .padding(.top, 5)
                        Text(tab.title)
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == tab.id ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 4)
        .background(tabBackgroundColor)
        .onChange(of: selectedTab) { newValue in
            if let item = tabs.first(where: { $0.id == selectedTab }) {
                if let color = item.bgColor {
                    tabBackgroundColor = color
                } else {
                    tabBackgroundColor = .white
                }
            }
        }
    }
}

struct MYKTabItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let content: () -> AnyView
    let canShowDivider: Bool
    let bgColor: Color?
    
    init<Content: View>(title: String, icon: String, canShowDivider: Bool, bgColor: Color, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.icon = icon
        self.canShowDivider = canShowDivider
        self.bgColor = bgColor
        self.content = { AnyView(LazyView(content)) }
    }
}

struct LazyView<Content: View>: View {
    let content: () -> Content
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        content()
    }
}
