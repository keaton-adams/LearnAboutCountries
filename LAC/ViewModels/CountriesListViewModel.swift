//
//  CountriesListViewModel.swift
//  LAC
//
//  Created by Keaton Adams on 9/18/25.
//

import Foundation
import SwiftUI

class CountriesListViewModel: ObservableObject {
    @Published var countries: [CountriesSchema.CountriesListQuery.Data.Country] = []
    
    private let countriesDataService: CountriesDataRetrieverProtocol
    init(countriesDataService: CountriesDataRetrieverProtocol = GraphQLCountriesRetriever()) {
        self.countriesDataService = countriesDataService
    }
    
    func getCountries() async throws {
        do {
            guard let countriesData = try await self.countriesDataService.getCountriesList() else { throw CountriesRetrieverError.failedToRetrieveCountries }
            await MainActor.run {
                self.countries = countriesData.compactMap{ $0 }
            }
        }
        catch {
            throw error
        }
    }
}
