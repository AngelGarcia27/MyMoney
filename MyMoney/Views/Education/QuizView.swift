import SwiftUI

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

struct QuizView: View {
    let title: String
    let questions: [QuizQuestion]
    @Environment(\.dismiss) var dismiss
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showExplanation = false
    @State private var score = 0
    @State private var quizCompleted = false
    
    private var currentQuestion: QuizQuestion {
        questions[currentQuestionIndex]
    }
    
    private var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count), height: 4)
                }
            }
            .frame(height: 4)
            
            if quizCompleted {
                // Results view
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: score == questions.count ? "star.fill" : "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(score == questions.count ? .yellow : .green)
                    
                    Text("Quiz Complete!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("You scored \(score) out of \(questions.count)")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    VStack(spacing: 12) {
                        ForEach(0..<questions.count, id: \.self) { index in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("Question \(index + 1)")
                                    .font(.subheadline)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Question number
                        Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        // Question
                        Text(currentQuestion.question)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        // Options
                        VStack(spacing: 12) {
                            ForEach(0..<currentQuestion.options.count, id: \.self) { index in
                                Button {
                                    if selectedAnswer == nil {
                                        selectedAnswer = index
                                        showExplanation = true
                                        if index == currentQuestion.correctAnswer {
                                            score += 1
                                        }
                                    }
                                } label: {
                                    OptionButton(
                                        text: currentQuestion.options[index],
                                        index: index,
                                        correctAnswer: currentQuestion.correctAnswer,
                                        selectedAnswer: selectedAnswer
                                    )
                                }
                                .disabled(selectedAnswer != nil)
                            }
                        }
                        
                        // Explanation
                        if showExplanation {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundStyle(.yellow)
                                    Text("Explanation")
                                        .font(.headline)
                                }
                                
                                Text(currentQuestion.explanation)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Spacer(minLength: 24)
                        
                        // Next button
                        if showExplanation {
                            Button {
                                if isLastQuestion {
                                    quizCompleted = true
                                } else {
                                    currentQuestionIndex += 1
                                    selectedAnswer = nil
                                    showExplanation = false
                                }
                            } label: {
                                Text(isLastQuestion ? "See Results" : "Next Question")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OptionButton: View {
    let text: String
    let index: Int
    let correctAnswer: Int
    let selectedAnswer: Int?
    
    private var backgroundColor: Color {
        if selectedAnswer == nil {
            return Color.black.opacity(0.04)
        } else if index == correctAnswer {
            return Color.green.opacity(0.1)
        } else if index == selectedAnswer {
            return Color.red.opacity(0.1)
        } else {
            return Color.black.opacity(0.04)
        }
    }
    
    private var borderColor: Color {
        if selectedAnswer == nil {
            return Color.clear
        } else if index == correctAnswer {
            return Color.green
        } else if index == selectedAnswer {
            return Color.red
        } else {
            return Color.clear
        }
    }
    
    var body: some View {
        HStack {
            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            if selectedAnswer != nil {
                if index == correctAnswer {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else if index == selectedAnswer {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                }
            }
        }
        .padding()
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        QuizView(
            title: "Budgeting Quiz",
            questions: [
                QuizQuestion(
                    question: "What percentage of your income should go to needs in the 50/30/20 rule?",
                    options: ["30%", "50%", "20%", "40%"],
                    correctAnswer: 1,
                    explanation: "The 50/30/20 rule suggests allocating 50% of your income to needs, 30% to wants, and 20% to savings."
                )
            ]
        )
    }
}
