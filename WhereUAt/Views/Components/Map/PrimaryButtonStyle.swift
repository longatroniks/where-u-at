//
//  PrimaryButtonStyle.swift
//  WhereUAt
//
//  Created by Karlo Longin (RIT Student) on 08.12.2023..
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
