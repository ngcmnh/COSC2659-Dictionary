/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Minh Anh
 ID: S3931980
 Created date: 14/09/2023
 Last modified: /09/2023
 Acknowledgement:
 https://stackoverflow.com/questions/69002861/controlling-size-of-texteditor-in-swiftui
 https://developer.apple.com/tutorials/swiftui-concepts/driving-changes-in-your-ui-with-state-and-bindings
 */

import SwiftUI

struct NoteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let viewModel: NoteDetailViewModel
    
    // get from note list view
    @Binding var note: NoteModel
    @Binding var noteStatus: NoteStatus
    
    @State private var isEditing : Bool = false
    @State var bodyTextEditorHeight : CGFloat = 20
    
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
                VStack (alignment: .leading, spacing: 15) {
                    // -------- EDIT MODE ----------------
                    if isEditing {
                        TextEditor(text: $note.title)
                            .frame(width: (viewModel.screenWidth - viewModel.horizontalPadding*2))
                            .frame(minHeight: (UIFont.preferredFont(forTextStyle: .largeTitle).pointSize+7))
                            .scaledToFit()
                            .font(.title)
                            .bold()
                            .foregroundColor(Color("Text"))
                            .disableAutocorrection(true)
                            .lineLimit(1)
                        
                        
                        Text("\(note.dateCreated.formatted(.dateTime.hour().minute().day().month().year()))")
                            .font(.subheadline)
                            .foregroundColor(Color("Text").opacity(0.6))
                        
                        ZStack {
                            Text(note.body)
                                .font(.body)
                                .foregroundColor(.clear)
                                .lineSpacing(5)
                                .padding(14)
                                .background(GeometryReader {
                                    Color.clear.preference(key: ViewHeightKey.self, value: $0.frame(in: .local).size.height)
                                })
                            TextEditor(text: $note.body)
                                .frame(height: max(40,bodyTextEditorHeight))
                            //                                .scrollDisabled(true)
                                .autocorrectionDisabled(true)
                                .foregroundColor(Color("Text"))
                                .lineSpacing(5)
                        }
                        .onPreferenceChange(ViewHeightKey.self) { bodyTextEditorHeight = $0 }
                    }
                    // -------- VIEW MODE ----------------
                    else {
                        Text(note.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(Color("Text"))
                        
                        Text("\(note.dateCreated.formatted(.dateTime.hour().minute().day().month().year()))")
                            .font(.subheadline)
                            .foregroundColor(Color("Text").opacity(0.6))
                        
                        Text(note.body)
                            .foregroundColor(Color("Text"))
                            .lineSpacing(5)
                    }
                }
            }
            .padding(.horizontal, viewModel.horizontalPadding)
        }
        .onChange(of: note.title) { newValue in
            if newValue.count > viewModel.maxChars {
                note.title = String(newValue.prefix(viewModel.maxChars))
            }
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(viewModel: NoteDetailViewModel(), note: .constant(NoteModel.sample), noteStatus: .constant(.none))
    }
}

// Needed for dynamic texteditor height
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
