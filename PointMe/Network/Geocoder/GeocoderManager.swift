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
    
    private func createAdressFromData(data: [String : Any]) -> String {
        let keys: [String] = ["response", "GeoObjectCollection"]
        let lastKeys: [String] = ["GeoObject", "metaDataProperty", "GeocoderMetaData"]
        var jsonData: [String: Any] = data
        
        for key in keys {
            jsonData = (jsonData[key] as? [String: Any]) ?? [:]
        }
        
        let arrayJsonData: [[String: Any]] = (jsonData["featureMember"] as? [[String : Any]]) ?? [[:]]
        jsonData = arrayJsonData.first ?? [:]
        
        for key in lastKeys {
            jsonData = (jsonData[key] as? [String: Any]) ?? [:]
        }
        
        return (jsonData["text"] as? String) ?? "Неизвестный адрес"
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
                completion(.success(self.createAdressFromData(data: json)))
            }
        }
        
        dataTask.resume()
    }
    
}
