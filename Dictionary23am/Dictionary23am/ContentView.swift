

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
                        NoteListView(tempNote: NoteModel.sample, noteStatus: .none, showingAddNoteView: false)
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
