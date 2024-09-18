
import Foundation

typealias BreedsInfoCompletion = (([DMBreedsInfo]?, Error?)->())
typealias FavoritesCompletion = (([DMFavorites]?, Error?)->())
typealias RandomDogsCompletion = (([DMRandomDogs]?, Error?)->())
typealias ImageForCarusel = (([DMCarousel]?, Error?)->())

protocol NetworkServiceBreeds {
    func loadBreeds(completion:@escaping BreedsInfoCompletion)
    func addToFavorites(imageID: String, completion: @escaping (Bool, Error?) -> Void)
    func loadFavorites(completion:@escaping FavoritesCompletion)
    func getRandomDogs(completion:@escaping RandomDogsCompletion)
    func removeFavorite(favoriteID: Int32, completion: @escaping (Bool, Error?) -> Void)
    func getImageForCarousel(breedID: Int32, completion: @escaping ImageForCarusel)

}

extension NetworkService: NetworkServiceBreeds {
 
    func getImageForCarousel(breedID: Int32, completion: @escaping ([DMCarousel]?, Error?) -> Void) {
        let urlString = "https://api.thedogapi.com/v1/images/search?limit=10&breed_ids=\(breedID)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(APIConstants.api_key, forHTTPHeaderField: "x-api-key")
        
        request(urlRequest: urlRequest) { (result: Result<[DMCarousel], Error>) in
            switch result {
            case .success(let value):
//                print("Received data: \(value)")
                completion(value, nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func getRandomDogs(completion: @escaping ([DMRandomDogs]?, Error?) -> Void){
        
        let urlString = "https://api.thedogapi.com/v1/images/search?limit=10"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(APIConstants.api_key, forHTTPHeaderField: "x-api-key")
        
        request(urlRequest: urlRequest) { (result: Result<[DMRandomDogs], Error>) in
            switch result {
            case .success(let value):
//                print("Received data: \(value)")
                completion(value, nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    
    
    
    func loadBreeds(completion: @escaping ([DMBreedsInfo]?, Error?) -> Void) {
        let urlString = "\(APIConstants.getBreedsUrl())"
       
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        request(urlRequest: urlRequest) { (result: Result<[DMBreedsInfo], Error>) in
            switch result {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }

    
    func addToFavorites(imageID: String, completion: @escaping (Bool, Error?) -> Void) {
        let urlString = "https://api.thedogapi.com/v1/favourites"
        guard let url = URL(string: urlString) else {
            completion(false, NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(APIConstants.api_key, forHTTPHeaderField: "x-api-key")
   
        let body: [String: String] = [
                "image_id": imageID
            ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            urlRequest.httpBody = jsonData
            print("JSON data: \(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON")")
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
            completion(false, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP status code: \(httpResponse.statusCode)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to add to favorites: Invalid response or status code")
                completion(false, NSError(domain: "", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Failed to add to favorites"]))
                return
            }
            
            print("Successfully added to favorites.")
            completion(true, nil)
        }
        task.resume()

    }

        
    
    func loadFavorites(completion: @escaping FavoritesCompletion) {

        let urlString = "\(APIConstants.addFavoritesUrl())"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(APIConstants.api_key, forHTTPHeaderField: "x-api-key")

        request(urlRequest: urlRequest) { (result: Result<[DMFavorites], Error>) in
            switch result {
            case .success(let value):

                completion(value, nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    
    
    
    func removeFavorite(favoriteID: Int32, completion: @escaping (Bool, Error?) -> Void) {
            let urlString = "https://api.thedogapi.com/v1/favourites/\(favoriteID)"
            guard let url = URL(string: urlString) else {
                completion(false, NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue(APIConstants.api_key, forHTTPHeaderField: "x-api-key")
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    completion(true, nil)  
                } else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                    let errorDescription = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    completion(false, NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorDescription]))
                }
            }.resume()
        }
    }
    

        private func request(urlRequest: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: 1002, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                completion(.success(data))
            }
            task.resume()
        }




