/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: 23AMDictionary
 ID: s3907086, s3904422, s3880604, s3904901, s3931980
 Created date: 16/09/2023
 Last modified: 20/09/2023
 Acknowledgement:
 https://dictionaryapi.dev/
 https://gist.github.com/vikaskore/b8e68cb324da31121c8bc6a061e51612
 https://github.com/rckim77/Sudoku
 https://youtu.be/0ytO3wCRKZU?si=ZgDxBYqK_RAJ_pJ0
 https://www.appicon.co/#image-sets
 https://www.flaticon.com/free-icon/books_2704442?term=book&page=1&position=89&origin=tag&related_id=2704442
 https://youtu.be/vzQDKYIKEb8?si=ghJQlGU6RkVpWLv-
 https://stackoverflow.com/questions/69002861/controlling-size-of-texteditor-in-swiftui
 https://developer.apple.com/tutorials/swiftui-concepts/driving-changes-in-your-ui-with-state-and-bindings
 https://www.youtube.com/watch?v=6b2WAePdiqA
 https://www.youtube.com/watch?v=uqkUumqFiF8
 https://www.youtube.com/watch?v=UeOi5H3HJOE
 https://www.youtube.com/watch?v=8MLdq9kotII
 https://www.youtube.com/watch?v=uhTRQ4TWQ9g
 https://www.youtube.com/watch?v=FFWP7eXn0ck
 https://matteomanferdini.com/mvvm-pattern-ios-swift/
 https://developer.apple.com/design/human-interface-guidelines/typography#Specifications
 https://developer.apple.com/design/human-interface-guidelines/dark-mode
 https://developer.apple.com/design/human-interface-guidelines/layout
 https://developer.apple.com/design/human-interface-guidelines/text-fields
 https://developer.apple.com/design/human-interface-guidelines/navigation-bars
 */

import Foundation
import AVFoundation

enum Category: Int {
    case shortDescription
    case fullDescription
    case pronounce
    case synonym
    case antonym
}
enum SearchState {
    case none, searched, cleared
}

class DictionaryViewModel: ObservableObject, ViewModel {
    
    @Published var entry: DictionaryEntry?
    @Published var word: String = ""
    @Published var selectedSegment = 0
    @Published var selectedCategory = Category.shortDescription
    @Published var searchState: SearchState = .none
    var player: AVPlayer?
    
    // To play pronunciation
    func playAudio(from url: String) {
        guard let audioURL = URL(string: url) else { return }
        player = AVPlayer(url: audioURL)
        player?.play()
    }
    
    // Fetch words definitions
    func fetchDefinition() {
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en_US/\(word)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let entries = try JSONDecoder().decode([DictionaryEntry].self, from: data)
                DispatchQueue.main.async {
                    self.entry = entries.first
                }
            } catch {
                print("Failed to parse dictionary entry: \(error)")
                self.entry = nil
                self.searchState = .searched
            }
        }
        task.resume()
    }
    
    // UI controller
    var topPadding: CGFloat {
        if isIpad {
            return 40
        } else {
            return 0
        }
    }
    
    var horizontalPadding: CGFloat {
        if isIpad {
            return 40
        } else {
            return 18
        }
    }
    
    var buttonWidth: CGFloat {
        if isIpad {
            return 80
        } else {
            return 60
        }
    }
}
