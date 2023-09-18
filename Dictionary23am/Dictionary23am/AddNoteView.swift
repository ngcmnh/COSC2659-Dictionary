//
//  addNoteView.swift
//  Dictionary23am
//
//  Created by Minh Dang Cong on 15/09/2023.
//

import SwiftUI

struct AddNoteView: View {
    // This will hold the text the user types into the TextEditor.
    @State private var noteContent: String = ""
    @State private var showAlert: Bool = false // 1. State variable for alert display
    @Environment(\.presentationMode) var presentationMode
    @Binding var notes: [NoteModel]


    var body: some View {
        NavigationView {
            ZStack {
                //yellow background
                Color("yellowbg").ignoresSafeArea(.all, edges: .all)
                
                VStack(spacing: 4) { // reduce the spacing between elements in the VStack
                    TextEditor(text: $noteContent)
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 2))
                        .cornerRadius(8)
                        .padding(.bottom, 4) // Add padding only to the bottom

                    Text("Character count: \(noteContent.count)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .padding(.top, 0) // No top padding
                }
                .padding() // Apply general padding to the VStack
                .navigationTitle("Add Note")
                .navigationBarItems(leading: cancelButton, trailing: saveButton)
                .toolbar {
                    // Adding a ToolbarItem for the Clear button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        clearButton
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Are you sure?"),
                                  message: Text("Do you want to clear all written notes?"),
                                  primaryButton: .destructive(Text("Clear")) {
                                      self.noteContent = ""
                                  },
                                  secondaryButton: .cancel()
                            )
                        }
                    }
            }
            }
        }
    }

    // Step 3: Add Save and Cancel buttons.
    private var cancelButton: some View {
        Button(action: {
            // Logic to cancel the note addition and dismiss the view.
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .bold))
            }
    }

    //save the text in the text field
    private var saveButton: some View {
        Button(action: {
            // Create a new note
//                   let newNote = Note(content: noteContent, isSelected: false)
//
//                   // Append the new note to the list
//                   notes.append(newNote)
                   
                   // Dismiss the view
                   presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save")
        }
        .fixedSize() // Fixes the size of the button
        .padding(.horizontal, 15) // Adjusted padding
        .padding(.vertical, 8)
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(30)
    }

    //clear all text in the text field
    private var clearButton: some View {
        Button(action: clearAction) {
            Text("Clear")
                .frame(minWidth: 0, maxWidth: .infinity) // This will take as much width as possible
        }
        .padding(.horizontal, 10) // reduced padding
        .padding(.vertical, 8)
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(30)
    }

    
    func clearAction() {
        showAlert = true // 2. Toggle the showAlert state
    }
}

struct AddNoteView_Previews: PreviewProvider {
    @State static var sampleNotes: [NoteModel] = []

    static var previews: some View {
        AddNoteView(notes: $sampleNotes)
    }
}
