//
//  ProfileHeaderView.swift
//  WhereUAt
//
//  Created by Karlo Longin (RIT Student) on 08.12.2023..
//

import SwiftUI

struct ProfileHeader: View {
    @Binding var username: String
    @Binding var email: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Username: \(username)")
                .font(.title2)
                .bold()
            Text("Email: \(email)")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}
