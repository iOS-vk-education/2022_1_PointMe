import Foundation


final class GeocoderManager {
    static let shared: GeocoderManager = GeocoderManager()
    
    private init() {}
    
    private func createURL(latitude: Double, longitude: Double) -> String {
        let arrayParams: [String] = [
            "https://geocode-maps.yandex.ru/1.x/?",
            "apikey=d9ca6766-8d6c-4d73-b84c-a74b311de5be",
            "&geocode=\(longitude),\(latitude)",
            "&format=json",
            "&results=1"
        ]
        
        return arrayParams.joined(separator: "")
    }
    
    private func createAddressFromData(data: [String : Any]) -> String {
        let keys4featureMember: [String] = ["response", "GeoObjectCollection", "featureMember"]
        let keys4address: [String] = ["GeoObject", "metaDataProperty", "GeocoderMetaData", "text"]
        
        guard let featureMember = (data as NSDictionary).value(
            forKeyPath: keys4featureMember.joined(separator: ".")
        ) as? [[String : Any]] else {
            return "Неизвестный адрес"
        }
        
        guard let geoObjectsJson = featureMember.first else {
            return "Неизвестный адрес"
        }
        
        guard let address = (geoObjectsJson as NSDictionary).value(
            forKeyPath: keys4address.joined(separator: ".")
        ) as? String else {
            return "Неизвестный адрес"
        }
        
        let array = address.split(separator: ",").filter {
            !$0.contains("Россия") && !$0.contains("административный округ") && !$0.contains("подъезд")
        }
        
        return array.joined(separator: ",")
    }
    
    func loadDataPlaceBy(latitude: Double, longitude: Double, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url: URL = URL(string: createURL(latitude: latitude, longitude: longitude)) else {
            completion(.failure(NSError()))
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, reponse, error in
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(.failure(NSError()))
                }
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError()))
                }
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                DispatchQueue.main.async {
                    completion(.failure(NSError()))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(self.createAddressFromData(data: json)))
            }
        }
        
        dataTask.resume()
    }
    
}
