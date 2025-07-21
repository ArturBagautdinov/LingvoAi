//
//  QuizView.swift
//  LingvoAi
//
//  Created by Artur Bagautdinov on 21.07.2025.
//
import SwiftUI
import OpenAI

struct QuizView: View {
    @State private var question: String = "Press 'Generate Question' to start"
    @State private var options: [String] = []
    @State private var selectedAnswer: String?
    @State private var isCorrect: Bool?
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var selectedLevel: EnglishLevel = .b1
    @State private var showLevelPicker: Bool = false
    
    private let openAI = OpenAI(apiToken: "")
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack(spacing: 20) {
                VStack {
                    Text("English Quiz")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Button(action: {
                        showLevelPicker.toggle()
                    }) {
                        HStack {
                            Text(selectedLevel.rawValue.uppercased())
                                .font(.system(size: 25, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            Image(systemName: "chevron.down")
                        }
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                if showLevelPicker {
                    VStack {
                        ForEach(EnglishLevel.allCases, id: \.self) { level in
                            Button(action: {
                                selectedLevel = level
                                showLevelPicker = false
                            }) {
                                Text(level.rawValue.uppercased())
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(selectedLevel == level ? Color.purple.opacity(0.3) : Color.clear)
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.darkGray).opacity(0.3))
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
                    .padding(.horizontal)
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding()
                } else {
                    Text(question)
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            checkAnswer(selectedOption: option)
                        }) {
                            Text(option)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(buttonColor(for: option))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(selectedAnswer != nil)
                    }
                    
                    if selectedAnswer != nil {
                        VStack {
                            Text(isCorrect == true ? "Correct! 🎉" : "Incorrect 😕")
                                .font(.headline)
                                .foregroundColor(isCorrect == true ? .green : .red)
                            
                            if !isCorrect!, let correctAnswer = options.first {
                                Text("Correct answer: \(correctAnswer)")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    
                    Button(action: generateQuestion) {
                        Text("Generate Question")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .padding(.top)
                }
            }
            .padding()
            .animation(.easeInOut, value: showLevelPicker)
        }
    }
    
    private func buttonColor(for option: String) -> Color {
        if selectedAnswer == nil {
            return Color.blue.opacity(0.7)
        }
        
        if option == selectedAnswer {
            return isCorrect == true ? Color.green : Color.red
        }
        
        return Color.gray.opacity(0.5)
    }
    
    private func generateQuestion() {
        isLoading = true
        errorMessage = nil
        selectedAnswer = nil
        isCorrect = nil
        
        let levelDescription = selectedLevel.description
        let prompt = """
        Generate an English language quiz question at \(levelDescription) level with 4 multiple choice options. 
        The question should test grammar, vocabulary or common expressions appropriate for this level.
        Format the response as JSON with "question" and "options" fields, 
        and include the correct answer as the first option.
        Example:
        {
            "question": "What is the capital of France?",
            "options": ["Paris", "London", "Berlin", "Madrid"]
        }
        """
        
        let query = ChatQuery(
            model: .gpt3_5Turbo,
            messages: [.init(role: .user, content: prompt)]
        )
        
        Task {
            do {
                let result = try await openAI.chats(query: query)
                if let content = result.choices.first?.message.content {
                    if let data = content.data(using: .utf8) {
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                        if let question = json?["question"] as? String,
                           let options = json?["options"] as? [String] {
                            DispatchQueue.main.async {
                                self.question = question
                                self.options = options.shuffled()
                                self.isLoading = false
                            }
                            return
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse question. Please try again."
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func checkAnswer(selectedOption: String) {
        selectedAnswer = selectedOption
        isCorrect = options.first == selectedOption
    }
}

enum EnglishLevel: String, CaseIterable {
    case a1 = "A1"
    case a2 = "A2"
    case b1 = "B1"
    case b2 = "B2"
    case c1 = "C1"
    
    var description: String {
        switch self {
        case .a1: return "beginner (A1)"
        case .a2: return "elementary (A2)"
        case .b1: return "intermediate (B1)"
        case .b2: return "upper intermediate (B2)"
        case .c1: return "advanced (C1)"
        }
    }
}
struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}

