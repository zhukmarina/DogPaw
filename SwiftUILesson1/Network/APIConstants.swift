//
//  APIConstants.swift
//  NewsClient
//
//  Created by Marina Zhukova on 07.06.2024.
//

import Foundation

struct APIConstants {
    static let baseUrl = "https://api.thedogapi.com/"
    static let apiVersion = "v1/"
    static let endpoints = "breeds"
    static let endpointsForSearch = "everything"

    static let api_key = "live_bJoGirr2hS1OfHTgyWqD3puQMHAxj6q9pZMC45QtDNE8E1GuQkVfsLzoHIIUN97M"
    
    
    static func getBreedsUrl() -> String {
        return baseUrl + apiVersion + endpoints
    }
    
//    static func searchNewsUrl() -> String {
//        return baseUrl + apiVersion + endpointsForSearch
//    }

}



