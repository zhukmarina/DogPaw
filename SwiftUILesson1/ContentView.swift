import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                
                if selectedTab == 0 {
                    Spacer()
                    DogsListView()
                    Spacer()
                    
                    } else if selectedTab == 1 {

                        BreedsListView()
                        Spacer()
                            } else if selectedTab == 2 {
                                FavoritesView(viewModel: DogsViewModel())
                                    
                            }
                
                NavPanel(selectedTab: $selectedTab)

            }

            
        }
        
    }
}

#Preview {
    ContentView()
}

