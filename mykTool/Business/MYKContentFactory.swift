//
//  MYKContentFactory.swift
//  mykTools
//
//  Created by 薛 on 2025/1/15.
//

import Foundation
import SwiftUI

class MYKContentFactory {
    
}

func creatContentTabItems() -> [MYKTabItem] {
    let tabs: [MYKTabItem] = [
        MYKTabItem(title: "主页", icon: "house", canShowDivider: false, bgColor: Color.customBackground) {
            MYKFeedPage()
        },
        MYKTabItem(title: "浏览器", icon: "safari", canShowDivider: false, bgColor: .white) {
            MYKWebContainerView()
        },
        MYKTabItem(title: "音乐", icon: "music.note.list", canShowDivider: true, bgColor: .white) {
            MYKMusicPlayerView()
        },
        MYKTabItem(title: "设置", icon: "gearshape", canShowDivider: true, bgColor: .white) {
            MYKSettingsView()
        }
    ]
    return tabs
}

