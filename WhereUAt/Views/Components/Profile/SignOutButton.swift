//
//  SignOutButton.swift
//  WhereUAt
//
//  Created by Karlo Longin (RIT Student) on 08.12.2023..
//

import SwiftUI

struct SignOutButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Sign Out")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding()
    }
}
