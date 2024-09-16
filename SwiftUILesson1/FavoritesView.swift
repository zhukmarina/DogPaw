

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject var viewModel: DogsViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.favorites, id: \.id) { favorite in
                VStack(alignment: .leading) {
                    // Відображення зображення собаки
                    if let imageUrl = URL(string: favorite.image?.url ?? "") {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    
                    HStack {
                        Text("You liked this guy:")
                          
                        if let createdAt = favorite.created_at {
                            Text(" \(formatDate(createdAt) ?? "Unknown date")")
                                .font(.subheadline)
                                
                        } else {
                            Text("Дата не доступна")
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(10)
                   
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.removeFavorite(favoriteID: Int(favorite.id ?? 0))
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                }
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 1)
                )
                .padding(.vertical, 1)
            }
            .navigationTitle("Favorite Dogs")
            .onAppear {
                viewModel.loadFavorites()
            }
        }
    }
}

#Preview {
    FavoritesView(viewModel: DogsViewModel())
}
