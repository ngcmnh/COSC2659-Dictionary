

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .book
    
    init() {
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
                        ViewB()
                    case .leaf:
                        ViewC()
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
        ContentView()
    }
}
