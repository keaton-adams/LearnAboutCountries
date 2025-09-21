//
//  CountryListView.swift
//  LAC
//
//  Created by Keaton Adams on 9/20/25.
//

import SwiftUI

struct CountryListView: View {
    @StateObject private var viewModel: CountriesListViewModel = CountriesListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.countries.isEmpty {
                    List(viewModel.countries, id: \.code) { country in
                        NavigationLink(destination: CountryDetailView(countryCode: country.code)) {
                            HStack {
                                Text(country.emoji).font(.headline)
                                    .accessibilityLabel("Country flag emoji")
                                Text(country.name).font(.headline)
                                    .accessibilityLabel("Country name")
                            }
                        }
                    }
                } else {
                    ProgressView("Loading countries...")
                }
            }
        }
        .task {
            do {
                try await viewModel.getCountries()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    CountryListView()
}
