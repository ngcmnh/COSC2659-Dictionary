/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Doan Hoang Anh
 ID: S3880604
 Created date: 16/09/2023
 Last modified: 20/09/2023
 Acknowledgement:
 
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
