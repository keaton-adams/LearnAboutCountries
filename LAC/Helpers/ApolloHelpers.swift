//
//  ApolloHelpers.swift
//  LAC
//
//  Created by Keaton Adams on 9/18/25.
//

import Apollo

extension ApolloClient {
  func fetchAsync<Q: GraphQLQuery>(query: Q, cachePolicy: CachePolicy = .returnCacheDataElseFetch) async throws -> Q.Data {
    try await withCheckedThrowingContinuation { continuation in
      self.fetch(query: query, cachePolicy: cachePolicy) { result in
        do {
            let value = try result.get()
            if let data = value.data {
                continuation.resume(returning: data)
            }
            else if let error = value.errors?.first {
                continuation.resume(throwing: error)
            }
            else {
                continuation.resume(throwing: GraphQLError.noData)
            }
        } catch {
            continuation.resume(throwing: error)
        }
      }
    }
  }
}

enum GraphQLError: Error {
    case noData
}
