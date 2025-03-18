//
//  ContentView.swift
//  ResumeAI
//
//  Created by Admin on 18/03/2025.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to ResumeAI")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Create professional resumes & cover letters with AI")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                VStack(spacing: 15) {
                    NavigationLink(destination: ResumeInputView()) {
                        Text("Create Resume")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    NavigationLink(destination: CoverLetterView()) {
                        Text("Generate Cover Letter")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding()
        }
    }
}
#Preview {
    ContentView()
}
