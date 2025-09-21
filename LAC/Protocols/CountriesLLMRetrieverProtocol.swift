//
//  CountriesLLMRetrieverProtocol.swift
//  LAC
//
//  Created by Keaton Adams on 9/19/25.
//

import Foundation

protocol CountriesLLMRetrieverProtocol {
    func getCountrySummary(country: CountriesSchema.CountryDetailQuery.Data.Country) async throws -> String?
    func getCountryFunFact(country: CountriesSchema.CountryDetailQuery.Data.Country) async throws -> String?
}

enum CountriesLLMRetrieverError: Error {
    case failedToRetrieveSummary
    case failedToRetrieveFunFact
    case failedToLoadDetail
}

enum LLMPrompts {
    static func summary(_ country: CountriesSchema.CountryDetailQuery.Data.Country) -> String {
            """
            Summarize \(country.name) in 3 short sentences.
            """
  }

  static func funFact(_ country: CountriesSchema.CountryDetailQuery.Data.Country) -> String {
      "Give one verifiable fun fact about \(country.name) in 1 sentence."
  }
}
