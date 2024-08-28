
import Foundation
import Combine

class BreedsViewModel: ObservableObject {
    
    @Published var breeds: [DMBreedsInfo] = []
    @Published var errorMessage: String?
    
    private var networkService: NetworkServiceBreeds
    
    init(networkService: NetworkServiceBreeds = NetworkService()) {
        self.networkService = networkService
    }
    
    func loadBreeds() {
        networkService.loadBreeds { [weak self] breedsInfo, error in
            DispatchQueue.main.async {
                if let breedsInfo = breedsInfo {
                    print("Number of breeds received: \(breedsInfo.count)")
                    self?.breeds = breedsInfo
                } else if let error = error {
                    print("Failed to load breeds: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
