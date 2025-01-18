func fetchData() async throws -> Data {
    let url = URL(string: "https://api.example.com/data")!
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
        // More comprehensive error handling based on HTTP status code
        throw NetworkError(statusCode: httpResponse?.statusCode ?? -1, description: HTTPURLResponse.localizedString(forStatusCode: httpResponse?.statusCode ?? -1))
    }

    return data
}

enum NetworkError: Error {
    case invalidURL
    case badServerResponse(statusCode: Int, description: String)
    case other(Error)
}

Task { 
    do {
        let data = try await fetchData()
        // process data
    } catch {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .badServerResponse(let code, let description):
                print("Network error: \(code) - \(description)")
            default:
                print("Error fetching data: \(error)")
            }
        } else {
            print("Error fetching data: \(error)")
        }
    }
}