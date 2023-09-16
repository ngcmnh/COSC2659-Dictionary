

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .book
    @Binding var isLoggedIn: Bool
    
    init(isLoggedIn: Binding<Bool>) {
        _isLoggedIn = isLoggedIn
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack {
            VStack {
                // MARK: -Display Each View
                TabView(selection: $selectedTab) {
                    switch selectedTab {
                    case .book:
                        DictionaryView()
                    case .person:
                        ProfileView(isLoggedIn: $isLoggedIn)
                    case .leaf:
                        DictionaryView()
                    }
                }
            }
            
            VStack{
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isLoggedIn: .constant(true))
    }
}
