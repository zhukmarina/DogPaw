//
//  DMRandomDogs.swift
//  SwiftUILesson1
//
//  Created by Marina Zhukova on 04.09.2024.
//

import Foundation

struct DMRandomDogs: Identifiable, Decodable {
    let breeds: [Breeds]
    let id: String?
    let url: String?
    let width: Int32?
    let height: Int32?
    
    struct Breeds: Decodable {
        let id: Int32
        let name: String?
        let bred_for: String?
        let breed_group: String?
        let life_span: String?
        let temperament: String?
        let origin: String?
        let reference_image_id: String?
    }
}


