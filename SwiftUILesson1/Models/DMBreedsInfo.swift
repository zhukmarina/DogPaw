import Foundation

struct DMBreedsInfo: Identifiable, Decodable {
    let id: Int32
    let name: String?
    let bred_for: String?
    let breed_group: String?
    let life_span: String?
    let temperament: String?
    let origin: String?
    let reference_image_id: String?
    let weight: Weight?
    let height: Height?
    let country_code: String? 

}

struct Weight: Decodable {
    let imperial: String
    let metric: String
}

struct Height: Decodable {
    let imperial: String
    let metric: String
}
