//
//  DogsViewModel.swift
//  SwiftUILesson1
//
//  Created by Marina Zhukova on 04.09.2024.
//

import Combine
import SwiftUI

class DogsViewModel: ObservableObject {
    @Published var breeds: [DMBreedsInfo] = []
    @Published var dogs: [DMRandomDogs] = []
    @Published var favorites: [DMFavorites] = []
    @Published var errorMessage: String?
    @Published var carusel: [DMCarousel] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var networkService: NetworkServiceBreeds
    
        init(networkService: NetworkServiceBreeds = NetworkService()) {
            self.networkService = networkService
        }
      
    func loadBreeds() {
        networkService.loadBreeds { [weak self] breedsInfo, error in
            DispatchQueue.main.async {
                if let breedsInfo = breedsInfo {
                    self?.breeds = breedsInfo
                } else if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
        func getRandomDogs() {
            networkService.getRandomDogs{ [weak self] randomDogs, error in
                DispatchQueue.main.async {
                    if let randomDogs = randomDogs {
                        self?.dogs = randomDogs
                    } else if let error = error {
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    
    func getImageForCarousel(breedID: Int32) {
        networkService.getImageForCarousel(breedID: breedID) { [weak self] carusel, error in
          
                DispatchQueue.main.async {
                    if let carusel = carusel {
                        self?.carusel = carusel
                     
                    } else if let error = error {
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
    }
    
    func loadFavorites() {
        networkService.loadFavorites { [weak self] favorites, error in
            DispatchQueue.main.async {
                if let favorites = favorites {
                    self?.favorites = favorites
                } else if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    

        func addToFavorites(imageID: String) {
            networkService.addToFavorites(imageID: imageID) { [weak self] success, error in
                DispatchQueue.main.async {
                    if success {
                        print("addToFavorites called with imageID: \(imageID)")
                    } else if let error = error {
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    
    func removeFavorite(favoriteID: Int) {
        NetworkService().removeFavorite(favoriteID: Int32(favoriteID)) { success, error in
            DispatchQueue.main.async {
                if success {
                   self.favorites.removeAll { $0.id ?? 0 == favoriteID }
                    print("Successfully removed favorite.")
                } else {
                    print("Failed to remove favorite: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    


}




