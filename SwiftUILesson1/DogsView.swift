import SwiftUI

struct DogsListView: View {
    
    @StateObject private var viewModel = DogsViewModel()
    @State private var isPressed = false
    @State private var currentIndex: Int = 0
    @State private var isLoading = true  // Для основного завантаження
    @State private var isCaruselLoading = false  // Для завантаження каруселі
    
    var filteredDogs: [DMRandomDogs] {
        return viewModel.dogs.filter { !$0.breeds.isEmpty }
    }
    
    var body: some View {
        VStack {
            if isLoading {
                // Індикатор завантаження для початкового стану
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
            } else if !filteredDogs.isEmpty {
                let dog = filteredDogs[currentIndex]
                VStack {
                    if let breed = dog.breeds.first {
                        if isCaruselLoading {
                            // Індикатор завантаження під час перемикання каруселі
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.5)
                                .padding()
                                .frame(height: 300)
                        } else {
                            // Оновлюємо карусель з новим breedID
                            Carusel(breedID: breed.id)
                                .frame(height: 300)
                            Text("\(breed.name ?? "")")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            
                            Text("\(breed.temperament ?? "")")
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    // Кнопки для перемикання та додавання в улюблені
                    HStack {
                        Button(action: {
                            // Перевірка, чи є наступна собака
                            if currentIndex < filteredDogs.count - 1 {
                                isCaruselLoading = true
                                currentIndex += 1
                            } else {
                                isCaruselLoading = true
                                currentIndex = 0 // Повернутись до початку, якщо це остання собака
                            }
                            // Затримка для імітації завантаження каруселі
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                isCaruselLoading = false
                            }
                        }) {
                            Image(systemName: "hand.thumbsdown")
                                .font(.title)
                        }
                        Spacer()
                        
                        if let breed = dog.breeds.first, let referenceImageID = breed.reference_image_id {
                            Button(action: {
                                if viewModel.favorites.contains(where: { $0.image_id == referenceImageID }) {
                                    if let favorite = viewModel.favorites.first(where: { $0.image_id == referenceImageID }) {
                                        viewModel.removeFavorite(favoriteID: Int(favorite.id ?? 0))
                                    }
                                } else {
                                    viewModel.addToFavorites(imageID: referenceImageID)
                                }
                            }) {
                                Image(systemName: viewModel.favorites.contains(where: { $0.image_id == referenceImageID }) || isPressed ? "heart.fill" : "heart")
                                    .font(.title)
                                    .foregroundColor(.red)
                                    .padding()
                                    .frame(width: 20)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if currentIndex < filteredDogs.count - 1 {
                                    isCaruselLoading = true
                                    currentIndex += 1
                                } else {
                                    isCaruselLoading = true
                                    currentIndex = 0
                                }
                                // Імітація затримки для завантаження
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    isCaruselLoading = false
                                }
                            }) {
                                Image(systemName: "hand.thumbsup")
                                    .font(.title)
                            }
                        }
                    }
                    .padding()
                }
            } else {
                Text("No dogs available")
            }
        }
        .navigationTitle("Voting dogs")
        .onAppear {
            viewModel.getRandomDogs()
            viewModel.loadFavorites()
            // Коли дані завантажені, знімаємо індикатор завантаження
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isLoading = false
            }
        }
    }
}

#Preview {
    DogsListView()
}
