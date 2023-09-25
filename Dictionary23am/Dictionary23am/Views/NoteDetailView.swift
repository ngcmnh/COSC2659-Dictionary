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
import Firebase

struct NoteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var notelistVM: NoteListViewModel
    let viewModel = NoteDetailViewModel()
    
    // get from note list view
    @Binding var note: NoteModel
    @Binding var noteStatus: NoteStatus
    
    @State private var isEditing : Bool = false
    @State var bodyTextEditorHeight : CGFloat = 20
    
    let currentUserID = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack (alignment: .leading) {
            // ---------- TopBar -----------------------
            HStack (alignment: .center) {
                Button {
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.backward")
                }
                .padding(.horizontal, 15)
                .foregroundColor(Color("Primary"))
                
                Spacer()
                
                if isEditing {
                    Button {
                        noteStatus = .none
                        isEditing.toggle()
                        
                        notelistVM.addOrUpdateNote(note)

                        // Save the updated note to Firestore
                        notelistVM.saveToFirestore(note: note, userId: currentUserID!) { success in
                            if success {
                                print("Successfully saved note.")
                            } else {
                                print("Failed to save note.")
                            }
                        }
                        
                        // change status to update list view
                        if noteStatus == .create {
                            // create request
                            noteStatus = .none
                        } else {
                            // update request
                            noteStatus = .none
                        }
                        
                    } label: {
                        Text("Save")
                    }
                    .padding(.horizontal, 15)
                    .foregroundColor(Color("Primary"))
                } else {
                    Button {
                        noteStatus = .update
                        isEditing.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.large)
                    }
                    .padding(.horizontal, 15)
                    .foregroundColor(Color("Primary"))
                }
            }
            .padding(.bottom, 10)
            // ------------------------------------------
            ScrollView {
                VStack (alignment: .leading, spacing: viewModel.spacing) {
                    // -------- EDIT MODE ----------------
                    if isEditing {
                        TextEditor(text: $note.title)
                            .frame(width: (viewModel.screenWidth - viewModel.horizontalPadding*2))
                            .frame(minHeight: (UIFont.preferredFont(forTextStyle: .largeTitle).pointSize+7))
                            .scaledToFit()
                            .font(Font(viewModel.title1))
                            .bold()
                            .foregroundColor(Color("Text"))
                            .disableAutocorrection(true)
                            .lineLimit(1)
                        
                        
                        Text("\(note.dateCreated.formatted(.dateTime.hour().minute().day().month().year()))")
                            .font(Font(viewModel.subHeadline))
                            .foregroundColor(Color("Text").opacity(0.6))
                        
                        // ZStack needed for dynamic text editor
                        ZStack {
                            Text(note.body)
                                .font(Font(viewModel.body))
                                .foregroundColor(.clear)
                                .lineSpacing(5)
                                .padding(14)
                                .background(GeometryReader {
                                    Color.clear.preference(key: ViewHeightKey.self, value: $0.frame(in: .local).size.height)
                                })
                            TextEditor(text: $note.body)
                                .frame(height: max(40,bodyTextEditorHeight))
                                .autocorrectionDisabled(true)
                                .foregroundColor(Color("Text"))
                                .lineSpacing(5)
                        }
                        .onPreferenceChange(ViewHeightKey.self) { bodyTextEditorHeight = $0 }
                    }
                    // -------- VIEW MODE ----------------
                    else {
                        Text(note.title)
                            .font(Font(viewModel.title1))
                            .bold()
                            .foregroundColor(Color("Text"))
                        
                        Text("\(note.dateCreated.formatted(.dateTime.hour().minute().day().month().year()))")
                            .font(Font(viewModel.subHeadline))
                            .foregroundColor(Color("Text").opacity(0.6))
                        
                        Text(note.body)
                            .font(Font(viewModel.body))
                            .foregroundColor(Color("Text"))
                            .lineSpacing(5)
                    }
                }
            }
            .padding(.horizontal, viewModel.horizontalPadding)
        }
        // Limit title's characters
        .onChange(of: note.title) { newValue in
            if newValue.count > viewModel.maxChars {
                note.title = String(newValue.prefix(viewModel.maxChars))
            }
        }
        .onAppear() {
            if noteStatus == .create {
                isEditing = true
            }
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(note: .constant(NoteModel.sample), noteStatus: .constant(.none))
    }
}

// Needed for dynamic texteditor height
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
