//
//  CountryDetailViewModel.swift
//  LAC
//
//  Created by Keaton Adams on 9/20/25.
//

import Foundation

class CountryDetailViewModel: ObservableObject {
    @Published var country: CountriesSchema.CountryDetailQuery.Data.Country?
    @Published var countrySummary: String?
    @Published var countryFunFact: String?
    @Published var countryIsFavorite: Bool = false
    
    private let countriesDataService: CountriesDataRetrieverProtocol
    private let countriesLLMService: CountriesLLMRetrieverProtocol
    private let favorites: FavoritesStore
    private let countryCode: String
    
    init(countryCode: String, _ countriesDataService: CountriesDataRetrieverProtocol = GraphQLCountriesRetriever(), _ countriesLLMService: CountriesLLMRetrieverProtocol = OpenAILLMService(apiKey: Constants.llmAPIKey)) {
        self.countryCode = countryCode
        self.countriesDataService = countriesDataService
        self.countriesLLMService = countriesLLMService
        self.favorites = .shared
        self.countryIsFavorite = favorites.isFavorite(code: countryCode)
    }
    
    func getCountryDetails(code: String) async throws {
        do {
            guard let countriesData = try await self.countriesDataService.getCountryDetails(code: code) else { throw CountriesRetrieverError.failedToRetrieveCountryDetails }
            await MainActor.run {
                self.country = countriesData
            }
        }
        catch {
            throw error
        }
    }
    
    func getSummary() async throws {
        do {
            guard let country = self.country else { throw CountriesRetrieverError.failedToRetrieveCountryDetails }
            guard let summaryData = try await self.countriesLLMService.getCountrySummary(country: country) else { throw CountriesLLMRetrieverError.failedToRetrieveSummary}
            await MainActor.run {
                self.countrySummary = summaryData
            }
        }
        catch {
            throw error
        }
    }
    
    func getFunFact() async throws {
        do {
            guard let country = self.country else { throw CountriesRetrieverError.failedToRetrieveCountryDetails }
            guard let summaryData = try await self.countriesLLMService.getCountryFunFact(country: country) else { throw CountriesLLMRetrieverError.failedToRetrieveFunFact}
            await MainActor.run {
                self.countryFunFact = summaryData
            }
        }
        catch {
            throw error
        }
    }
    
    func toggleFavorite(code: String) {
        self.countryIsFavorite = favorites.toggle(code: code)
    }
}
