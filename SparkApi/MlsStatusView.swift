//
//  MlsStatusView.swift
//  SparkApi
//
//  Created by Alex Beattie on 5/22/24.
//

import SwiftUI

struct MlsStatusView: View {
    let listing: ActiveListings.StandardFields
    
    var body: some View {
        VStack {
            if listing.MlsStatus == "Active" {
                Text(listing.MlsStatus ?? "")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.gray)
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
            } else if listing.MlsStatus == "Pending" || listing.MlsStatus == "Active Under Contract" {
                Text(listing.MlsStatus ?? "")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.red)
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
            } else {
                Text(listing.MlsStatus ?? "Unknown Status")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.gray)
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
            }
        }
    }
}

func lowercaseSmallCaps(_ text: String) -> some View {
    Text(text.uppercased())
//        .font(.system(.body, design: .default))
//        .fontWeight(.regular)
//        .textCase(.lowercase)
}
