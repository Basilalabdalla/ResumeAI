import SwiftUI
import UIKit // Import UIKit for UIPasteboard

struct ResumeInputView: View {
    @State private var generatedResume = "Your AI-generated resume will appear here."
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var experience = ""
    @State private var isLoading = false
    @State private var summary = ""
    @State private var experienceSection = ""
    @State private var education = ""
    @State private var skills = ""

    var body: some View {
        VStack {
            Text("Enter Your Resume Details")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            TextField("Full Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Phone Number", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $experience)
                .border(Color.gray, width: 1)
                .padding()

            Button(action: {
                guard !name.isEmpty, !email.isEmpty, !phone.isEmpty, !experience.isEmpty else {
                    generatedResume = "Please fill in all fields."
                    return
                }

                let prompt = "Write a short test sentence."
/*
"""
Create a professional resume in a modern format for \(name).

Contact Information:
Email: \(email)
Phone: \(phone)

Experience Summary:
\(experience)

Include sections for: Summary, Work Experience (with bullet points detailing responsibilities and achievements), Education, and Skills. Format dates as MM/YYYY. Highlight key accomplishments.

Return the data in JSON format, with the keys: "summary", "experience", "education", "skills".
"""
*/
                isLoading = true
                Task { [self] in
                    do {
                        let response = try await GeminiAPI().generateResponse(for: prompt)
                        if let data = response.data(using: .utf8) {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                                summary = json["summary"] ?? ""
                                experienceSection = json["experience"] ?? ""
                                education = json["education"] ?? ""
                                skills = json["skills"] ?? ""
                                generatedResume = "Resume Generated!"
                            } else {
                                generatedResume = "Invalid JSON format."
                            }
                        } else {
                            generatedResume = "No data received."
                        }
                    } catch {
                        generatedResume = "Error: \(error.localizedDescription)"
                        print("Gemini API Error: \(error)")
                    }
                    isLoading = false
                }
            }) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Generate Resume")
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
                    Text("Summary")
                        .font(.headline)
                    Text(summary)
                        .padding(.bottom)

                    Text("Experience")
                        .font(.headline)
                    Text(experienceSection)
                        .padding(.bottom)

                    Text("Education")
                        .font(.headline)
                    Text(education)
                        .padding(.bottom)

                    Text("Skills")
                        .font(.headline)
                    Text(skills)

                    Button(action: {
                        UIPasteboard.general.string = "\(summary)\n\n\(experienceSection)\n\n\(education)\n\n\(skills)"
                    }) {
                        Text("Copy Resume")
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
    ResumeInputView()
}
