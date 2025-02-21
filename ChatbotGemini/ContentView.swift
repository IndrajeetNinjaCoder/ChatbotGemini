//
//  ContentView.swift
//  ChatbotGemini
//
//  Created by test on 20/02/25.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    @State private var userPrompt: String = ""
    @State private var response: String = "How can I help you?"
    @State private var isLoading: Bool = false
    
    @State private var historyArr: [String] = []
    
    var body: some View {
        VStack {
            Text("Chatbot - Gemini AI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.indigo)
                .padding(.top)
            
            if historyArr.isEmpty {
                Text("Hi there, How can I help you?")
                    .font(.title2)
                    .padding()
            }
            
            ZStack {
                List(Array(historyArr.enumerated()), id: \.element) { index, text in
                    Text(text)
                        .padding()
                        .background(index % 2 == 0 ? Color.indigo.opacity(0.4) : Color.blue.opacity(0.4))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: index % 2 == 0 ? .trailing : .leading)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                    
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                        .scaleEffect(3)
                }
            }
            
            HStack {
                TextField("Ask Anything...", text: $userPrompt, axis: .vertical)
                    .lineLimit(5)
                    .font(.title3)
                    .padding()
                    .background(Color.indigo.opacity(0.2))
                    .cornerRadius(16)
                    .onSubmit {
                        historyArr.append(userPrompt)
                        generateResponse()
                    }
                
                Button(action: {
                    historyArr.append(userPrompt)
                    if !userPrompt.isEmpty {
                        generateResponse()
                    }
                }) {
                    Image(systemName: "paperplane.circle.fill")
                        .scaleEffect(2.5)
                        .padding()
                }
            }
            .padding()
        }
    }
    
    
    func generateResponse() {
        isLoading = true
        response = ""
        Task {
            do {
                let result = try await model.generateContent(userPrompt)
                isLoading = false
                response = result.text ?? "No response found"
                historyArr.append(response)
                userPrompt = ""
            } catch {
                response = "Something went wrong \n \(error.localizedDescription)"
            }
        }
    }
}


#Preview {
    ContentView()
}
