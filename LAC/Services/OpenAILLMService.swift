//
//  OpenAILLMService.swift
//  LAC
//
//  Created by Keaton Adams on 9/19/25.
//

import Foundation

final class OpenAILLMService: CountriesLLMRetrieverProtocol {
    private let openAIModelURL = URL(string: "https://api.openai.com/v1/chat/completions")
    private static let openAIModelName = "gpt-3.5-turbo"
    private let apiKey: String
    private let model: String
    private let session: URLSession
    
    init(apiKey: String, model: String = openAIModelName, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.model = model
        self.session = session
    }
    
    func getCountrySummary(country: CountriesSchema.CountryDetailQuery.Data.Country) async throws -> String? {
        try await chat(LLMPrompts.summary(country), temp: 0.2, maxTokens: 140)
    }
    
    func getCountryFunFact(country: CountriesSchema.CountryDetailQuery.Data.Country) async throws -> String? {
        try await chat(LLMPrompts.funFact(country), temp: 0.8, maxTokens: 80)
    }
    
    private func chat(_ prompt: String, temp: Double, maxTokens: Int) async throws -> String {
        var request = URLRequest(url: openAIModelURL!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": "You are a concise, factual assistant for a countries learning app. Keep answers 1–3 sentences."],
                ["role": "user",   "content": prompt]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
        guard let text = decoded.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
            return "Unable to generate content"
        }
        return text
    }
}

private struct ChatResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable { let content: String }
        let message: Message
    }
    let choices: [Choice]
}

enum Constants {
    static let llmAPIKey: String = {
        guard let key = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            fatalError("OPENAI_API_KEY not found")
        }
        return key
    }()
}
