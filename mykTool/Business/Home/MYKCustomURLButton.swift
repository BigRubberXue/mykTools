//
//  MYKCustomURLButton.swift
//  mykTools
//
//  Created by 薛 on 2025/1/15.
//

import SwiftUI

struct MYKCustomURLButton: View {
    let url: MYKCustomURL
    let isEditing: Bool
    let onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                if !isEditing {
                    openURL(url.urlString)
                }
            }) {
                VStack(spacing: 12) {
                    Image(systemName: "link")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                    Text(url.name)
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fill)
                .padding()
                .background(Color.customButton)
                .cornerRadius(15)
            }
            
            if isEditing {
                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 24))
                }
                .offset(x: 10, y: -10)
            }
        }
    }
}
