//
//  API.swift
//  SparkApi
//
//  Created by Alex Beattie on 5/20/24.
//

import Foundation

struct API {
    static func fetchActiveListings(queryItems: [URLQueryItem] = []) async throws -> [ActiveListings.ListingResult] {
        let url = constructURL(for: "listings", queryItems: queryItems)
        let listingData: ActiveListings.ListingData = try await fetchData(from: url)
        return listingData.D.Results
    }

    private static func constructURL(for endpoint: String, queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "replication.sparkapi.com"
        components.path = "/v1/\(endpoint)"
        components.queryItems = queryItems

        guard let url = components.url else {
            fatalError("Invalid URL components: \(components)")
        }
        return url
    }

    private static func fetchData<T: Decodable>(from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.addValue("Bearer \(Constants.TOKEN)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
