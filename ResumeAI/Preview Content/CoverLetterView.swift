//
//  CoverLetterView.swift
//  ResumeAI
//
//  Created by Admin on 18/03/2025.
//
import SwiftUI
import UIKit

struct CoverLetterView: View {
    @State private var generatedCoverLetter = "Your AI-generated cover letter will appear here."
    @State private var jobTitle = ""
    @State private var companyName = ""
    @State private var experienceSummary = ""
    @State private var isLoading = false
    @State private var introduction = ""
    @State private var bodyText = ""
    @State private var conclusion = ""

    var body: some View {
        VStack {
            Text("Enter Cover Letter Details")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            TextField("Job Title", text: $jobTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Company Name", text: $companyName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $experienceSummary)
                .border(Color.gray, width: 1)
                .padding()

            Button(action: {
                guard !jobTitle.isEmpty, !companyName.isEmpty, !experienceSummary.isEmpty else {
                    generatedCoverLetter = "Please fill in all fields."
                    return
                }

                let prompt = "Write a one sentence cover letter for a \(jobTitle) at \(companyName)."

                isLoading = true
                Task { [self] in
                    do {
                        let response = try await GeminiAPI().generateResponse(for: prompt)
                        introduction = response // Directly assign response to introduction
                        generatedCoverLetter = response
                        bodyText = ""
                        conclusion = ""
                    } catch {
                        generatedCoverLetter = "Error: \(error.localizedDescription)"
                        print("Gemini API Error: \(error)")
                    }
                    isLoading = false
                }
            }) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Generate Cover Letter")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)

            ScrollView {
                VStack(alignment: .leading) {
                    Text("Introduction")
                        .font(.headline)
                    Text(introduction)
                        .padding(.bottom)

                    Text("Body")
                        .font(.headline)
                    Text(bodyText)
                        .padding(.bottom)

                    Text("Conclusion")
                        .font(.headline)
                    Text(conclusion)

                    Button(action: {
                        UIPasteboard.general.string = "\(introduction)\n\n\(bodyText)\n\n\(conclusion)"
                    }) {
                        Text("Copy Cover Letter")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

#Preview {
    CoverLetterView()
}
