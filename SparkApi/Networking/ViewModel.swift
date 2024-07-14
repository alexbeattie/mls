import SwiftUI
import Combine
import Foundation

@MainActor
class ListingViewModel: ObservableObject {
    
    @Published var results: [ActiveListings.ListingResult] = []
    @Published var closedListings: [ActiveListings.ListingResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasMoreData = true

    private var currentPage = 1
    private var pageSize: Int

    private var cancellables = Set<AnyCancellable>()

    enum ListingType {
        case active
        case closed
    }

    init(pageSize: Int = 5) { // Default page size is 5
        self.pageSize = pageSize
        fetchListings(of: .active)
    }

    func fetchListings(of type: ListingType) {
        currentPage = 1
        hasMoreData = true
        fetchPage(of: type)
    }

    func fetchNextPage(of type: ListingType) {
        guard !isLoading, hasMoreData else { return }
        currentPage += 1
        fetchPage(of: type)
    }

    private func fetchPage(of type: ListingType) {
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
            URLQueryItem(name: Constants.QueryKeys.limit, value: "\(pageSize)"),
            URLQueryItem(name: Constants.QueryKeys.pagination, value: "1"),
            URLQueryItem(name: Constants.QueryKeys.page, value: "\(currentPage)"),
            URLQueryItem(name: Constants.QueryKeys.filter, value: "MlsId eq '\(Constants.MLSID)' And ListAgentId Eq '\(Constants.aaronkirman)' And StandardStatus Eq '\(status)'"),
            URLQueryItem(name: Constants.QueryKeys.orderby, value: "-ListPrice"),
            URLQueryItem(name: Constants.QueryKeys.expand, value: "Photos,Documents,Videos,VirtualTours,OpenHouses,CustomFields")
        ]

        fetchListings(queryItems: queryItems)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Error fetching listings: \(error.localizedDescription)"
                    self.isLoading = false
                case .finished:
                    break
                }
            }, receiveValue: { listings in
                if self.currentPage == 1 {
                    if type == .active {
                        self.results = listings
                    } else {
                        self.closedListings = listings
                    }
                } else {
                    if type == .active {
                        self.results.append(contentsOf: listings)
                    } else {
                        self.closedListings.append(contentsOf: listings)
                    }
                }
                self.hasMoreData = listings.count == self.pageSize
                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    private func fetchListings(queryItems: [URLQueryItem]) -> AnyPublisher<[ActiveListings.ListingResult], Error> {
        Future { promise in
            Task {
                do {
                    let listings = try await API.fetchListings(queryItems: queryItems)
                    promise(.success(listings))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
