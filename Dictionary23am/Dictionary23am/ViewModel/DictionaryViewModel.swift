

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

class DictionaryViewModel: ObservableObject {
    
    @Published var entry: DictionaryEntry?
    @Published var word: String = ""
    @Published var selectedSegment = 0
    @Published var selectedCategory = Category.shortDescription
    @Published var searchState: SearchState = .none
    var player: AVPlayer?
    
    func playAudio(from url: String) {
        guard let audioURL = URL(string: url) else { return }
        player = AVPlayer(url: audioURL)
        player?.play()
    }
    
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
}
