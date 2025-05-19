//
//  LikeButton.swift
//  WhereUAt
//
//  Created by Karlo Longin (RIT Student) on 08.12.2023..
//

import SwiftUI

struct LikeButton: View {
    let isLiked: Bool
    let likesCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 3) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .red : .gray)
                Text("\(likesCount)")
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
