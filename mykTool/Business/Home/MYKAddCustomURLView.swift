//
//  MYKAddCustomURLView.swift
//  mykTools
//
//  Created by 薛 on 2025/1/15.
//

import SwiftUI

struct MYKAddCustomURLView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var dataManager: MYKAppDataManager
    @State private var name = ""
    @State private var urlString = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("名称", text: $name)
                TextField("URL", text: $urlString)
            }
            .navigationTitle("添加自定义URL")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    let newURL = MYKCustomURL(name: name, urlString: urlString)
                    dataManager.addCustomURL(customUrl: newURL)
                    dismiss()
                }
                .disabled(name.isEmpty || urlString.isEmpty)
            )
        }
    }
}
    

