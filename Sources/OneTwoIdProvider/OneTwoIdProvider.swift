import Foundation
import Alamofire

public struct OneTwoIdProvider {
    public private(set) var text = "Hello, World!"

        public init() {
        }
        public static func makeGetRequest(completion: @escaping (Result<String, Error>) -> Void) {
            guard let url = URL(string: "https://swapi.dev/api/") else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            AF.request(url)
                .response { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: [])
                            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

                            if let jsonString = String(data: jsonData, encoding: .utf8) {
                                completion(.success(jsonString))
                            } else {
                                completion(.failure(NSError(domain: "Unable to convert data to JSON string", code: 0, userInfo:
    nil)))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
}
