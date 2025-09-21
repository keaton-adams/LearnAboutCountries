//
//  GraphQLCountriesRetriever.swift
//  LAC
//
//  Created by Keaton Adams on 9/18/25.
//

import Foundation
import Apollo

final class GraphQLCountriesRetriever: CountriesDataRetrieverProtocol {
    private static let dataSourceURL: URL = URL(string: "https://countries.trevorblades.com/")!
    private let apolloClient: ApolloClient
    
    init(apolloClient: ApolloClient = ApolloClient(url: dataSourceURL)) {
        self.apolloClient = apolloClient
    }
    
    func getCountriesList() async throws -> [CountriesSchema.CountriesListQuery.Data.Country]? {
        let data = try await self.getCountriesData(query: CountriesSchema.CountriesListQuery())
        return data?.countries
            .compactMap { $0 }
            .sorted { $0.name < $1.name }
    }
    
    func getCountryDetails(code: String) async throws -> CountriesSchema.CountryDetailQuery.Data.Country? {
        let data = try await self.getCountriesData(query: CountriesSchema.CountryDetailQuery(code: code))
        return data?.country
    }
    
    private func getCountriesData<Q: GraphQLQuery>(query: Q) async throws -> Q.Data? {
        let data = try await apolloClient.fetchAsync(query: query)
        return data
    }
}
