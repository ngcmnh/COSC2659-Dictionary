//
//  DictionaryView.swift
//  Dictionary23am
//
//  Created by Minh Phan on 16/09/2023.
//

import SwiftUI

struct DictionaryView: View {
    
    @ObservedObject var viewModel = DictionaryViewModel()
    
    var body: some View {
        VStack {
            Text("Dictionary")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding(.bottom)
            
            TextField("Enter word", text: $viewModel.word, onCommit: {
                viewModel.fetchDefinition()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            Picker("Category", selection: $viewModel.selectedCategory) {
                Text("Short Description").tag(Category.shortDescription)
                Text("Full Description").tag(Category.fullDescription)
                Text("Pronounce").tag(Category.pronounce)
                Text("Synonym").tag(Category.synonym)
                Text("Antonym").tag(Category.antonym)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
            
            HStack(spacing: 20) {
                Button("Search") {
                    viewModel.fetchDefinition()
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color(red: 0.3, green: 0.6, blue: 1))
                .cornerRadius(20)
                
                Button("Clear") {
                    viewModel.entry = nil
                    viewModel.word = ""
                    viewModel.searchState = .cleared
                }
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color.red)
                .cornerRadius(20)
            }
            .padding(.bottom)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.8))
                .shadow(radius: 5)
                .overlay(
                    ScrollView {
                        VStack(alignment: .leading) {
                            if let entry = viewModel.entry {
                                Text("Word: \(entry.word)")
                                switch viewModel.selectedCategory {
                                case .shortDescription:
                                    if let firstDefinition = entry.meanings.first?.definitions.first {
                                        Text(firstDefinition.definition)
                                    }
                                case .fullDescription:
                                    ForEach(entry.meanings, id: \.partOfSpeech) { meaning in
                                        Text("\(meaning.partOfSpeech)")
                                        ForEach(meaning.definitions, id: \.definition) { definition in
                                            Text("- \(definition.definition)")
                                        }
                                    }
                                case .pronounce:
                                    ForEach(entry.phonetics, id: \.text) { phonetic in
                                        HStack {
                                            Text(phonetic.text ?? "Pronunciation")
                                            if let audioURL = phonetic.audio, !audioURL.isEmpty {
                                                Button(action: {
                                                    viewModel.playAudio(from: audioURL)
                                                }) {
                                                    Image(systemName: "play.circle.fill")
                                                        .foregroundColor(.blue)
                                                }
                                            }
                                        }
                                    }
                                case .synonym:
                                    if let synonyms = entry.meanings.first?.synonyms, !synonyms.isEmpty {
                                        Text("Synonyms: \(synonyms.joined(separator: ", "))")
                                    } else {
                                        Text("No synonyms available.")
                                    }
                                case .antonym:
                                    if let antonyms = entry.meanings.first?.antonyms, !antonyms.isEmpty {
                                        Text("Antonyms: \(antonyms.joined(separator: ", "))")
                                    } else {
                                        Text("No antonyms available.")
                                    }
                                }
                            } else {
                                switch viewModel.searchState {
                                case .none:
                                    Text("Enter search word!")
                                case .searched:
                                    Text("No results!")
                                case .cleared:
                                    Text("Enter search word!")
                                }
                            }
                        }
                        .padding()
                    }
                )
                .padding(.horizontal)
                .padding(.bottom, 80)
        }
        .padding()
    }
}
struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}
