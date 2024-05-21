import SwiftUI

struct MainTabView: View {
    @StateObject var viewModel = ListingViewModel()
    @State private var selectedTab = 0 // Set the initial tab programmatically

    var body: some View {
        TabView(selection: $selectedTab) {
            ActiveListingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            ClosedListingsView(viewModel: viewModel)
                          .tabItem {
                              Label("Closed Listings", systemImage: "house")
                          }
                .tag(1)
            
            ActiveListingsMapView(viewModel: ListingViewModel())
                        .tabItem {
                            Label("Active Map", systemImage: "map.fill")
                        }
                    ClosedListingsMapView(viewModel: ListingViewModel())
                        .tabItem {
                            Label("Closed Map", systemImage: "map")
                        }
//            NewMapView(listings: Array(viewModel.results))  // Ensure this matches the NewMapView initializer
//                .tabItem {
//                    Image(systemName: "map")
//                    Text("Map")
//                }
//                .tag(1)
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
