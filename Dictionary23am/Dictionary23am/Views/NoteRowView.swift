/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Dang Cong Minh
 ID: S390494
 Created date: 15/09/2023
 Last modified: 20/09/2023
 Acknowledgement:
 */

import SwiftUI

struct NoteRowView: View {
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

        }
    }
}


struct NoteRowView_Previews: PreviewProvider {
    static var previews: some View {
        NoteRowView(noteContent: "Sample Note Content")
    }
}

