//
//  CountryDetailView.swift
//  LAC
//
//  Created by Keaton Adams on 9/20/25.
//

import SwiftUI

struct CountryDetailView: View {
    @State var countryCode: String
    @StateObject private var viewModel: CountryDetailViewModel
    
    init(countryCode: String) {
        self.countryCode = countryCode
        _viewModel = StateObject(wrappedValue: CountryDetailViewModel(countryCode: countryCode))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let country = viewModel.country {
                    HStack(spacing: 8){
                        Text(country.emoji)
                            .accessibilityLabel("Country flag emoji")
                        Text(country.name)
                            .font(.title).bold()
                            .accessibilityLabel("Country name")
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "phone.fill")
                        Text("Prefix:")
                        Text(country.phone)
                            .accessibilityLabel("Country phone prefix")
                    }
                    .font(.subheadline)
                    if let capital = country.capital {
                        Text("Capital is \(capital)")
                            .font(.subheadline)
                            .accessibilityLabel("Country capital")
                    }

                    if let langs = (country.languages).map(\.name) as? [String],
                       !langs.isEmpty {
                        Text("Official languages: \(langs.joined(separator: ", "))")
                            .font(.subheadline)
                            .accessibilityLabel("Country official languages")
                    }

                    Divider()

                    HStack {
                        Text("Summary").font(.headline)
                        Spacer()
                        Button("Regenerate") { Task { try await viewModel.getSummary() } }
                            .buttonStyle(.bordered)
                            .tint(.primary)
                            .accessibilityLabel("Regenerate country summary")
                    }
                    if let countrySummary = viewModel.countrySummary {
                        Text(countrySummary)
                            .accessibilityLabel("Country summary")
                    } else {
                        ProgressView("Loading summary...")
                    }

                    HStack {
                        Text("Fun Fact").font(.headline)
                        Spacer()
                        Button("Regenerate") { Task { try await viewModel.getFunFact() } }
                            .buttonStyle(.bordered)
                            .tint(.primary)
                            .accessibilityLabel("Regenerate country fun fact")
                    }
                    if let countryFunFact = viewModel.countryFunFact {
                        Text(countryFunFact)
                            .accessibilityLabel("Country fun fact")
                    }
                    else {
                        ProgressView("Loading fun fact...")
                    }
                } else {
                    ProgressView("Loading…")
                }
            }
            .padding()
        }
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
              Button(action: { viewModel.toggleFavorite(code: countryCode) }) {
                Image(systemName: viewModel.countryIsFavorite ? "star.fill" : "star")
                .foregroundStyle(viewModel.countryIsFavorite ? .yellow : .secondary)
                .accessibilityLabel(viewModel.countryIsFavorite ? "Remove country from favorites" : "Add country to favorites")
            }
          }
        }
        .task {
            do {
                try await viewModel.getCountryDetails(code: countryCode)
                try await viewModel.getSummary()
                try await viewModel.getFunFact()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    CountryDetailView(countryCode: "US")
}
