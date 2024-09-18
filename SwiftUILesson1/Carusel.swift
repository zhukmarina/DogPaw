import SwiftUI

struct Carusel: View {
    @StateObject private var viewModel = DogsViewModel()
    let breedID: Int32
    
    var body: some View {
        VStack {
            if viewModel.carusel.isEmpty {
                ProgressView("Loading images...")
            } else {
                TabView {
                    ForEach(viewModel.carusel, id: \.id) { image in
                        if let imageUrl = URL(string: image.url ?? "") {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 300)
                                    .clipped()
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 300)
            }
        }
        .onAppear {
          
            viewModel.getImageForCarousel(breedID: breedID)
        }
        .onChange(of: breedID) { newBreedID in
           
            viewModel.getImageForCarousel(breedID: newBreedID)
        }
    }
}


#Preview {
    Carusel(breedID: 13)
}
