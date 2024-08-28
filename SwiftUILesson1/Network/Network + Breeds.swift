
import Foundation

typealias BreedsInfoCompletion = (([DMBreedsInfo]?, Error?)->())

protocol NetworkServiceBreeds {
    func loadBreeds(completion:@escaping BreedsInfoCompletion)

}

extension NetworkService: NetworkServiceBreeds {
    
    func loadBreeds(completion: @escaping ([DMBreedsInfo]?, Error?) -> Void) {
        let urlString = "\(APIConstants.getBreedsUrl())"
        print("Requesting URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        request(urlRequest: urlRequest) { (result: Result<[DMBreedsInfo], Error>) in
            switch result {
            case .success(let value):
                print("Received data: \(value)")
                completion(value, nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }

}

