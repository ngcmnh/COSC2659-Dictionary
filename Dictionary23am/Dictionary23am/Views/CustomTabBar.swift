/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Phan Nhat Minh
 ID: S3904422
 Created date: 16/09/2023
 Last modified: 19/09/2023
 Acknowledgement:
 https://youtu.be/vzQDKYIKEb8?si=ghJQlGU6RkVpWLv-
 */

import SwiftUI

// MARK: -Tab Icon
//Has to be the same name with SF app symbols
enum Tab: String, CaseIterable {
    case book
    case person
    case leaf
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    // MARK: -Tab Color
    private var tabColor: Color {
        switch selectedTab {
        case .book:
            return Color("Primary")
        case .person:
            return Color("Secondary")
        case .leaf:
            return Color("Tertiary")
        }
    }
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Spacer()
                Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                    .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                    .foregroundColor(selectedTab == tab ? tabColor : .gray)
                    .font(.system(size: 22))
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 0.1)) {
                            selectedTab = tab
                        }
                    }
                Spacer()
            }
        }
        .frame(width: nil, height: 60)
        .background(.thinMaterial)
        .cornerRadius(10)
        .padding()
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.leaf))
    }
}
