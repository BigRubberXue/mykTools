//
//  MYKSysFeatureButton.swift
//  mykTools
//
//  Created by 薛 on 2025/1/15.
//

import SwiftUI

struct MYKSysFeatureButton: View {
    let title: String
    let icon: String
    let urlString: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fill)
            .padding()
            .background(Color.customButton)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
            )
            .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}
