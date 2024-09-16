//
//  DMFavorites.swift
//  SwiftUILesson1
//
//  Created by Marina Zhukova on 03.09.2024.
//

import Foundation


struct DMFavorites: Identifiable, Decodable {
    
    let id: Int32?
    let user_id: String?
    let image_id: String?
    let created_at: String?
    let image: Image?
    
    struct Image: Decodable{
        let id: String
        let url: String
    }
    
}


