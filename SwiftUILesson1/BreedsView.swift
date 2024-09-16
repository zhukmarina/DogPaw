import SwiftUI
struct BreedsListView: View {
    
    @StateObject private var viewModel = DogsViewModel()
    @State private var searchText: String = ""
    @State private var selectedBreed: String = ""
    @State private var isPressed = false
    
    var filteredBreeds: [String] {
        if searchText.isEmpty {
            return viewModel.breeds.map { $0.name ?? "" }
        } else {
            return viewModel.breeds
                .map { $0.name ?? "" }
                .filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField("Select a breed", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: searchText) { newValue in
                        if !newValue.isEmpty {
                            let matches = filteredBreeds.filter { $0.lowercased().contains(newValue.lowercased()) }
                            if !matches.isEmpty {
                                selectedBreed = matches[0]
                            }
                        }
                    }
                
                Menu {
                    ForEach(filteredBreeds, id: \.self) { breed in
                        Button(breed) {
                            self.selectedBreed = breed
                            self.searchText = ""
                        }
                    }
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: "chevron.down")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Search for breeds")
            .padding(.horizontal)
            .onAppear {
                viewModel.loadBreeds()
                if let firstBreed = viewModel.breeds.first?.name {
                    self.searchText = firstBreed
                    self.selectedBreed = firstBreed
                    self.searchText = ""
                }
            }
            
            Spacer()
            
            // Відображення вибраної породи або скелетону
            VStack {
                if !selectedBreed.isEmpty {
                    // Відображення вибраної породи
                    Text("\(selectedBreed)")
                        .font(.custom("Papyrus", size: 24))
                        .foregroundColor(.purple)
                        .padding()
                    
                    if let breedInfo = viewModel.breeds.first(where: { $0.name == selectedBreed }) {
                        
                        if let referenceImageID = breedInfo.reference_image_id {
                            let imageUrl = "https://cdn2.thedogapi.com/images/\(referenceImageID).jpg"
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 300)
                                    .clipped()
                            } placeholder: {
                                // Placeholder для зображення
                                ZStack {
                                    Color.gray.opacity(0.1)
                                        .frame(height: 200)
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                }
                            }
                        }
                        
         

                        HStack {
                            
                            VStack {
                                Text("Temperament:")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(breedInfo.temperament ?? "")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Text("Life span:")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(breedInfo.life_span ?? "")
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Text("Size:")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text("\(breedInfo.height?.metric ?? "") сm, \(breedInfo.weight?.metric ?? "") kg")
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                               
                              
                            }
                            .padding()
                        }
                    }
                } else {
                    // Скелетон для порожнього стану
                    VStack {
                        Color.gray.opacity(0.1)
                            .frame(height: 300)
                            .cornerRadius(10)
                            .padding()
                        
                        Text("Select a breed to see details")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
            }
            .frame(height: 350)
            Spacer()
        }
    }
}
    #Preview {
        BreedsListView()
    }
