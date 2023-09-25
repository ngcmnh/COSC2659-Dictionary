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

import SwiftUI

struct DictionaryView: View {
    
    @ObservedObject var viewModel = DictionaryViewModel()
    
    // MARK: -Dictionary View
    var body: some View {
        VStack {
            VStack {
                // Search bar
                TextField("Enter word", text: $viewModel.word, onCommit: {
                    viewModel.fetchDefinition()
                })
                .textFieldStyle(PlainTextFieldStyle())
                .font(Font(viewModel.body))
                .foregroundColor(Color("Text"))
                .padding(.all, 8)
                .tint(Color("Tertiary"))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(Color("TextFieldBorder")))
            }
            .padding(.horizontal, viewModel.horizontalPadding)
            .padding(.top, viewModel.topPadding)
            
            // Filter Picker
            Picker("Category", selection: $viewModel.selectedCategory) {
                Text("Short Description").tag(Category.shortDescription)
                Text("Full Description").tag(Category.fullDescription)
                Text("Pronounce").tag(Category.pronounce)
                Text("Synonym").tag(Category.synonym)
                Text("Antonym").tag(Category.antonym)
            }
            .font(Font(viewModel.body))
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, 20)
            .padding(.bottom, 10)
            .padding(.horizontal, viewModel.horizontalPadding)
            
            // Search and clear buttons
            HStack(spacing: 20) {
                Button("Search") {
                    viewModel.fetchDefinition()
                }
                .font(Font(viewModel.body))
                .frame(width: viewModel.buttonWidth)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, viewModel.horizontalPadding)
                .background(Color("Primary"))
                .cornerRadius(10)
                
                Button("Clear") {
                    viewModel.entry = nil
                    viewModel.word = ""
                    viewModel.searchState = .cleared
                }
                .font(Font(viewModel.body))
                .frame(width: viewModel.buttonWidth)
                .foregroundColor(.black)
                .padding(.vertical, 10)
                .padding(.horizontal, viewModel.horizontalPadding)
                .background(Color("Secondary"))
                .cornerRadius(10)
            }
            .padding(.bottom, 10)
            
            // Search results field to display category
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("SearchResultBackground").opacity(0.8))
                .shadow(radius: 5)
                .overlay(
                    ScrollView {
                        VStack(alignment: .leading) {
                            if let entry = viewModel.entry {
                                Text("Word: \(entry.word)").font(Font(viewModel.body))
                                
                                // Display which word category to display
                                switch viewModel.selectedCategory {
                                case .shortDescription:
                                    if let firstDefinition = entry.meanings.first?.definitions.first {
                                        Text(firstDefinition.definition)
                                            .font(Font(viewModel.body))
                                    }
                                case .fullDescription:
                                    ForEach(entry.meanings, id: \.partOfSpeech) { meaning in
                                        Text("\(meaning.partOfSpeech)")
                                            .font(Font(viewModel.body))
                                        ForEach(meaning.definitions, id: \.definition) { definition in
                                            Text("- \(definition.definition)")
                                                .font(Font(viewModel.body))
                                        }
                                    }
                                case .pronounce:
                                    ForEach(entry.phonetics, id: \.text) { phonetic in
                                        HStack {
                                            Text(phonetic.text ?? "Pronunciation")
                                                .font(Font(viewModel.body))
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
                                            .font(Font(viewModel.body))
                                    } else {
                                        Text("No synonyms available.")
                                            .font(Font(viewModel.body))
                                    }
                                case .antonym:
                                    if let antonyms = entry.meanings.first?.antonyms, !antonyms.isEmpty {
                                        Text("Antonyms: \(antonyms.joined(separator: ", "))")
                                            .font(Font(viewModel.body))
                                    } else {
                                        Text("No antonyms available.")
                                            .font(Font(viewModel.body))
                                    }
                                }
                            } else {
                                switch viewModel.searchState {
                                case .none:
                                    Text("Enter search word!")
                                        .font(Font(viewModel.body))
                                case .searched:
                                    Text("No results!")
                                        .font(Font(viewModel.body))
                                case .cleared:
                                    Text("Enter search word!")
                                        .font(Font(viewModel.body))
                                }
                            }
                        }
                        .padding()
                    }
                )
                .padding(.horizontal, viewModel.horizontalPadding)
                .padding(.bottom, 85)
        }
        .padding(.top, 20)
    }
}
struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}
