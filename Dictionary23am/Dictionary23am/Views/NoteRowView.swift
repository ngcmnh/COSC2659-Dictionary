//
//  NoteListItemView.swift
//  Dictionary23am
//
//  Created by Minh Dang Cong on 15/09/2023.
//

import SwiftUI

struct NoteRowView: View {
//    @Binding var isDone: Bool
    let viewModel = NoteListViewModel()
    var noteContent: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(noteContent)
                    .font(Font(viewModel.body))
                    .padding(.horizontal, viewModel.horizontalPadding)
                    .padding(.vertical, viewModel.verticalPadding)
            }
            
            Spacer()
            
//            Button(action: {
//                isDone.toggle()
//            }) {
//                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
//            }
//            .contentShape(Rectangle()) // Capture all touches
//            .zIndex(1) // Ensure it's above other elements

        }
    }
}


struct NoteRowView_Previews: PreviewProvider {
//    @State static var sampleIsDone: Bool = false
    
    static var previews: some View {
        NoteRowView(noteContent: "Sample Note Content")
    }
}

