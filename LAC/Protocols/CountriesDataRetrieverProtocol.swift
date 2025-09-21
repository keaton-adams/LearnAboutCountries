//
//  CountriesDataRetrieverProtocol.swift
//  LAC
//
//  Created by Keaton Adams on 9/18/25.
//

import Foundation

protocol CountriesDataRetrieverProtocol {
    func getCountriesList() async throws -> [CountriesSchema.CountriesListQuery.Data.Country]?
    func getCountryDetails(code: String) async throws -> CountriesSchema.CountryDetailQuery.Data.Country?
}

enum CountriesRetrieverError: Error {
    case failedToRetrieveCountries
    case failedToRetrieveCountryDetails
}
