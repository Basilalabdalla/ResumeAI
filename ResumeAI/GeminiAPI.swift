//
//  GeminiAPI.swift
//  ResumeAI
//
//  Created by Admin on 18/03/2025.
//
import GoogleGenerativeAI
import Foundation

struct GeminiAPI {
    private let model: GenerativeModel

    init() {
        guard let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] else {
            fatalError("API key not found! Make sure to add it in your environment variables.")
        }

        self.model = GenerativeModel(name: "gemini-2.0-flash", apiKey: apiKey)
    }

    func generateResponse(for prompt: String) async throws -> String {
        let response = try await model.generateContent(prompt)
        if let text = response.text {
            return text
        } else {
            return "No response received."
        }
    }
}
/*
import GoogleGenerativeAI
import Foundation

struct GeminiAPI {
    private let model: GenerativeModel

    init() {
        guard let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] else {
            fatalError("API key not found! Make sure to add it in your environment variables.")
        }
        
        let config = GenerationConfig(
            temperature: 1,
            topP: 0.95,
            topK: 40,
            maxOutputTokens: 8192,
            responseMIMEType: "text/plain"
        )

        self.model = GenerativeModel(
            name: "gemini-2.0-flash",
            apiKey: apiKey,
            generationConfig: config
        )
    }

    func generateResponse(for prompt: String) async throws -> String {
        let chat = model.startChat(history: [
            ModelContent(role: "user", parts: [.text("Hello!")]),
            ModelContent(role: "model", parts: [.text("Hi there! How can I help?")])
        ])

        let response = try await chat.sendMessage(prompt)
        return response.text ?? "No response received."
    }
}
*/
