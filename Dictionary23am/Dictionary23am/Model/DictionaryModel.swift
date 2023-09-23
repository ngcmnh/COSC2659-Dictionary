/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Doan Hoang Anh
 ID: S3880604
 Created date: 12/09/2023
 Last modified: 23/09/2023
 Acknowledgement:
 
 */

import Foundation

struct DictionaryEntry: Codable {
    let word: String
    let phonetics: [Phonetic]
    let meanings: [Meaning]
    let license: License
    let sourceUrls: [String]
}

struct Phonetic: Codable {
    let audio: String?
    let sourceUrl: String?
    let license: License?
    let text: String?
}

struct License: Codable {
    let name: String
    let url: String
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
    let synonyms: [String]?
    let antonyms: [String]?
}

struct Definition: Codable {
    let definition: String
    let synonyms: [String]?
    let antonyms: [String]?
    let example: String?
}
