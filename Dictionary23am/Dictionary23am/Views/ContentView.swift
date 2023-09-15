//
//  ContentView.swift
//  Dictionary23am
//
//  Created by ngminh on 09/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .book
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    switch selectedTab {
                    case .book:
                        ViewA()
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
