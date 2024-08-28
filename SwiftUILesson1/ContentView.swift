import SwiftUI

struct BreedsListView: View {
    
    @StateObject private var viewModel = BreedsViewModel()
    @State private var searchText = ""
    
   
    
    // Фільтрування результатів пошуку
    private var searchResults: [DMBreedsInfo] {
        if searchText.isEmpty {
            return viewModel.breeds
        } else {
            return viewModel.breeds.filter { $0.name!.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(searchResults, id: \.id) { breed in
                VStack(alignment: .leading) {
                    
                   
                    if let referenceImageID = breed.reference_image_id {
                        let imageUrl = "https://cdn2.thedogapi.com/images/\(referenceImageID).jpg"
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                        } placeholder: {
                            ZStack {
                                Color.gray.opacity(0.1)
                                    .frame(height: 200)
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        }
                    }
                    
                    HStack{
                        Spacer()
                        Text("\(breed.name ?? "")")
                            .font(.largeTitle)
                        Spacer()
                    }
                    
                    
                    Text("Life span: \(breed.life_span ?? "")")
                        .font(.subheadline)
                    
                    Text("Temperament: \(breed.temperament ?? "")")
                        .font(.subheadline)
                    
                }
                .padding(.vertical, 5)
            }
            .searchable(text: $searchText)
            .navigationTitle("Breeds")
            .onAppear {
                viewModel.loadBreeds()
            }
        }
    }
}

#Preview {
    BreedsListView()
}
