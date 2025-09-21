// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension CountriesSchema {
  class CountryDetailQuery: GraphQLQuery {
    static let operationName: String = "CountryDetail"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query CountryDetail($code: ID!) { country(code: $code) { __typename code name emoji currencies capital phone languages { __typename code name } } }"#
      ))

    public var code: ID

    public init(code: ID) {
      self.code = code
    }

    public var __variables: Variables? { ["code": code] }

    struct Data: CountriesSchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { CountriesSchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("country", Country?.self, arguments: ["code": .variable("code")]),
      ] }

      var country: Country? { __data["country"] }

      /// Country
      ///
      /// Parent Type: `Country`
      struct Country: CountriesSchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { CountriesSchema.Objects.Country }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("code", CountriesSchema.ID.self),
          .field("name", String.self),
          .field("emoji", String.self),
          .field("currencies", [String].self),
          .field("capital", String?.self),
          .field("phone", String.self),
          .field("languages", [Language].self),
        ] }

        var code: CountriesSchema.ID { __data["code"] }
        var name: String { __data["name"] }
        var emoji: String { __data["emoji"] }
        var currencies: [String] { __data["currencies"] }
        var capital: String? { __data["capital"] }
        var phone: String { __data["phone"] }
        var languages: [Language] { __data["languages"] }

        /// Country.Language
        ///
        /// Parent Type: `Language`
        struct Language: CountriesSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { CountriesSchema.Objects.Language }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("code", CountriesSchema.ID.self),
            .field("name", String.self),
          ] }

          var code: CountriesSchema.ID { __data["code"] }
          var name: String { __data["name"] }
        }
      }
    }
  }

}