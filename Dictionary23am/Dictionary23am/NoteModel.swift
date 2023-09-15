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
 
 */

import Foundation

class NoteModel : ObservableObject {
    // ID
    var title: String
    var dateCreated: Date
    var body: String
    
    init(title: String, dateCreated: Date, body: String) {
        self.title = title
        self.dateCreated = dateCreated
        self.body = body
    }
}

extension NoteModel {
    static var sample = NoteModel(title: "Example Note", dateCreated: Date(), body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Consectetur a erat nam at. Purus non enim praesent elementum. Diam donec adipiscing tristique risus nec feugiat in. Ultrices neque ornare aenean euismod. Id ornare arcu odio ut. Id donec ultrices tincidunt arcu. Consectetur adipiscing elit ut aliquam purus. Ac turpis egestas sed tempus urna et pharetra pharetra massa. Quisque non tellus orci ac auctor augue mauris augue neque. Vitae semper quis lectus nulla at. Bibendum arcu vitae elementum curabitur vitae nunc sed velit. Faucibus interdum posuere lorem ipsum dolor sit. Sit amet facilisis magna etiam tempor orci eu lobortis. Commodo odio aenean sed adipiscing. Tristique senectus et netus et malesuada fames ac turpis egestas. Nisl pretium fusce id velit ut tortor pretium viverra suspendisse. Tristique sollicitudin nibh sit amet commodo nulla facilisi. Elementum pulvinar etiam non quam lacus suspendisse faucibus interdum.")
}
