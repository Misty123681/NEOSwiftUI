

import Foundation
import Combine

class ApiManager<T1 : Decodable> {
    
    class func fetchData(url : URL, parameters : [String : Any]? = nil, method : String, header : Bool = false) -> AnyPublisher<T1,Error> {
    
    
        var request = URLRequest(url: url)
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if header {
            request.addValue(UserDefaults.standard.value(forKey: "accessToken") as! String, forHTTPHeaderField: "access_token")
        }
        request.httpMethod = method
        if(method == "POST" && parameters != nil) {
            request.httpBody = parameters!.percentEncoded()
        }
        print("params..\(String(describing: parameters))")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                
                let json:AnyObject =  try (JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? NSDictionary)!
                print(json)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown
                }
                if (httpResponse.statusCode == 401) {
                    throw APIError.apiError(reason: "Unauthorized");
                }
                if (httpResponse.statusCode == 403) {
                    throw APIError.apiError(reason: "Resource forbidden");
                }
                if (httpResponse.statusCode == 404) {
                    throw APIError.apiError(reason: "Resource not found");
                }
                if (405..<500 ~= httpResponse.statusCode) {
                    throw APIError.apiError(reason: "client error");
                }
                if (500..<600 ~= httpResponse.statusCode) {
                    throw APIError.apiError(reason: "server error");
                }
                
                return data
        }
        .decode(type: T1.self,
                decoder: JSONDecoder())
            .mapError { error in
                print(error)
                return error
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
}

enum TestFailureCondition: Error {
    case invalidServerResponse
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}


enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String), parserError(reason: String), networkError(from: URLError)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason), .parserError(let reason):
            return reason
        case .networkError(let from):
            return from.localizedDescription
        }
    }
}
