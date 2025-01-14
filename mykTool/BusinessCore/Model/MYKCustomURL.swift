//
//  MYKCustomURL.swift
//  没眼看工具
//
//  Created by 薛 on 2025/1/5.
//

import Foundation


struct MYKCustomURL: Identifiable, Codable {
    var id = UUID()
    var name: String
    var urlString: String
}
