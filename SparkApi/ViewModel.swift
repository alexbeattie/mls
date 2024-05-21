import SwiftUI
import Combine
import Foundation




@MainActor
class ListingViewModel: ObservableObject {
    @Published var searchResults: [ActiveListings.ListingResult] = []
    @Published var closedListings: [ActiveListings.ListingResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    init() {
        fetchListings(of: .active)
    }

    enum ListingType {
        case active
        case closed
    }

    func fetchListings(of type: ListingType) {
        guard !isLoading else { return }
        isLoading = true

        let status: String
        switch type {
        case .active:
            status = "Active"
        case .closed:
            status = "Closed"
        }

        let queryItems = [
            URLQueryItem(name: Constants.QueryKeys.limit, value: "50"),
            URLQueryItem(name: Constants.QueryKeys.pagination, value: "1"),
            URLQueryItem(name: Constants.QueryKeys.filter, value: "MlsId eq '\(Constants.MLSID)' And ListAgentId Eq '\(Constants.lindamay)' And MlsStatus Eq '\(status)'"),
            URLQueryItem(name: Constants.QueryKeys.orderby, value: "-ListPrice"),
            URLQueryItem(name: Constants.QueryKeys.expand, value: "Photos,Documents,Videos,VirtualTours,OpenHouses,CustomFields")
        ]

        Task {
            do {
                let listings = try await API.fetchActiveListings(queryItems: queryItems)
                await MainActor.run {
                    switch type {
                    case .active:
                        self.searchResults = listings
                    case .closed:
                        self.closedListings = listings
                    }
                }

                if (type == .active && searchResults.isEmpty) || (type == .closed && closedListings.isEmpty) {
                    print("Results array is empty")
                } else {
                    print(type == .active ? searchResults : closedListings)
                }

            } catch {
                await MainActor.run {
                    self.errorMessage = "Error fetching listings: \(error)"
                }
            }
            isLoading = false
        }
    }
}
