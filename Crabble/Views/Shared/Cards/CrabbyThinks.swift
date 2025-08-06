import SwiftUI

struct CrabbyThinks: View {
    let bodyText: String
    let hasFixedSize: Bool
    let maxLines: Int
    let suggestions: [String]?
    let context: String
    let promptType: PromptType
    @Binding var shouldRetrigger: Bool
    
    // LLM Integration with Mindpath Prompts
    @StateObject private var conversationViewModel = ConversationViewModel(modelCategory: .gemma3n)
    
    // Expose a function to retrigger text generation
    func retriggerText() {
        resetAnimation()
        startLoadingAnimation()
    }
    
    @State private var displayedText = ""
    @State private var currentIndex = 0
    @State private var isLoading = true
    @State private var showLoadingDots = false
    @State private var isStreaming = false
    @State private var typingTimer: Timer?
    

    
    init(bodyText: String, hasFixedSize: Bool = false, maxLines: Int = 5, suggestions: [String]? = nil, context: String = "", promptType: PromptType = .taskBreakdown, shouldRetrigger: Binding<Bool> = .constant(false)) {
        self.bodyText = bodyText
        self.hasFixedSize = hasFixedSize
        self.maxLines = hasFixedSize ? maxLines : min(maxLines, 5)
        self.suggestions = suggestions
        self.context = context
        self.promptType = promptType
        self._shouldRetrigger = shouldRetrigger
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Main content
            HStack(spacing: 12) {
                // Circle Symbol with Brain Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#C7D2FE"), Color(hex: "#E9D5FF")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                    
                    Image("BrainIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color(hex: "#4F46E5"))
                }
                
                // Text Content
                VStack(alignment: .leading, spacing: 4) {
                    // Title with Music Icon
                    HStack(spacing: 4) {
                        Text("Crabby Thinks")
                            .font(.system(size: 12, weight: .medium))
                            .lineSpacing(16 - 12) // Line height 16px
                            .foregroundColor(Color(hex: "#4338CA"))
                        
                        Image("SparkleIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color(hex: "#4338CA"))
                    }
                    
                    // Body Text with Modern Typing Animation and LLM Integration
                    if hasFixedSize {
                        ZStack(alignment: .topLeading) {
                            if isLoading || isStreaming {
                                Text("...")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(hex: "#3730A3").opacity(showLoadingDots ? 1.0 : 0.3))
                                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: showLoadingDots)
                            } else {
                                Text(attributedDisplayedText)
                                    .font(.system(size: 14, weight: .regular))
                                    .lineSpacing(22 - 14)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(maxLines)
                                    .truncationMode(.tail)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .frame(height: CGFloat(maxLines) * 23, alignment: .top)
                    } else {
                        if isLoading || isStreaming {
                            Text("...")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "#3730A3").opacity(showLoadingDots ? 1.0 : 0.3))
                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: showLoadingDots)
                        } else {
                            Text(attributedDisplayedText)
                                .font(.system(size: 14, weight: .regular))
                                .lineSpacing(22 - 14)
                                .multilineTextAlignment(.leading)
                                .lineLimit(maxLines)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            
            // Suggestions section (optional)
            if let suggestions = suggestions, !suggestions.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    // Title
                    Text("Crabby suggests:")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "#4338CA"))
                        .padding(.horizontal, 16)
                    
                    // Suggestions buttons
                    VStack(spacing: 8) {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(action: {
                                handleSuggestionTap(suggestion)
                            }) {
                                HStack(spacing: 8) {
                                    Image("CalendarIcon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 14, height: 14)
                                        .foregroundColor(Color(hex: "#3730A3"))
                                    
                                    Text(suggestion)
                                        .font(.system(size: 14, weight: .regular))
                                        .lineSpacing(20 - 14) // Line height 20px
                                        .foregroundColor(Color(hex: "#3730A3"))
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(hex: "#E0E7FF").opacity(0.5))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#EEF2FF"), Color(hex: "#FAF5FF")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .stroke(Color(hex: "#E0E7FF"), lineWidth: 1)
        )
        .onAppear {
            startLoadingAnimation()
            observeConversationState()
            conversationViewModel.loadModel()
            generateMainText()
        }
        .onChange(of: bodyText) {
            resetAnimation()
            startLoadingAnimation()
        }
        .onChange(of: shouldRetrigger) { shouldRetrigger in
            if shouldRetrigger {
                // Retrigger text animation
                retriggerText()
                // Reset the trigger
                DispatchQueue.main.async {
                    self.shouldRetrigger = false
                }
            }
        }
        .onChange(of: conversationViewModel.currentState) { newState in
            handleStateChange(newState)
        }
    }
    
    private var attributedDisplayedText: AttributedString {
        var attributedString = AttributedString(displayedText)
        
        // Apply fade-in effect to recently added characters
        let totalLength = displayedText.count
        let recentChars = min(4, totalLength) // Show fade effect on last 4 characters (plus subtil)
        
        for i in 0..<totalLength {
            let startIndex = attributedString.index(attributedString.startIndex, offsetByCharacters: i)
            let endIndex = attributedString.index(startIndex, offsetByCharacters: 1)
            
            // Calculate opacity based on how recently the character was added
            let opacity: Double
            
            if i >= totalLength - recentChars {
                let position = recentChars > 1 ? Double(i - (totalLength - recentChars)) / Double(recentChars - 1) : 1.0
                opacity = 0.7 + (0.3 * position) // Fade from 70% to 100% (plus subtil)
            } else {
                opacity = 1.0
            }
            
            attributedString[startIndex..<endIndex].foregroundColor = Color(hex: "#3730A3").opacity(opacity)
        }
        
        return attributedString
    }
    
    private func resetAnimation() {
        // Stop any existing timer
        typingTimer?.invalidate()
        typingTimer = nil
        
        displayedText = ""
        currentIndex = 0
        isLoading = true
        showLoadingDots = false
    }
    
    private func startLoadingAnimation() {
        resetAnimation()
        showLoadingDots = true
    }
    
    private func startModernTypingAnimation() {
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if currentIndex < bodyText.count {
                let index = bodyText.index(bodyText.startIndex, offsetBy: currentIndex)
                displayedText += String(bodyText[index])
                currentIndex += 1
            } else {
                timer.invalidate()
                self.typingTimer = nil
            }
        }
        
        RunLoop.current.add(typingTimer!, forMode: .common)
    }
    
    private func observeConversationState() {
        Task { @MainActor in
            for await state in conversationViewModel.$currentState.values {
                handleStateChange(state)
            }
        }
    }
    
    private func handleStateChange(_ state: ConversationViewModel.State) {
        switch state {
        case .idle:
            resetAnimation()
        case .loadingModel:
            isLoading = true
            showLoadingDots = true
        case .promptSubmitted:
            isStreaming = true
            isLoading = false
            showLoadingDots = true
        case .streamingResponse:
            isStreaming = true
            isLoading = false
            showLoadingDots = false
            updateDisplayedTextFromMessages()
        case .done:
            isStreaming = false
            isLoading = false
            showLoadingDots = false
            updateDisplayedTextFromMessages()
        case .criticalError, .nonCriticalError:
            isStreaming = false
            isLoading = false
            showLoadingDots = false
            displayedText = "Sorry, I encountered an error. Please try again."
        }
    }
    
    private func updateDisplayedTextFromMessages() {
        if let lastSystemMessage = conversationViewModel.messageViewModels
            .filter({ $0.chatMessage.participant != .user })
            .last {
            displayedText = lastSystemMessage.chatMessage.text
            startTypingAnimation()
        }
    }
    
    private func startTypingAnimation() {
        currentIndex = 0
        displayedText = ""
        
        let responseText = conversationViewModel.messageViewModels
            .filter({ $0.chatMessage.participant != .user })
            .last?.chatMessage.text ?? bodyText
        
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if currentIndex < responseText.count {
                let index = responseText.index(responseText.startIndex, offsetBy: currentIndex)
                displayedText += String(responseText[index])
                currentIndex += 1
            } else {
                timer.invalidate()
                self.typingTimer = nil
            }
        }
        
        RunLoop.current.add(typingTimer!, forMode: .common)
    }
    
    private func handleSuggestionTap(_ suggestion: String) {
        let contextualPrompt = """
        You are Crabby, a supportive AI assistant. The user clicked on this suggestion: "\(suggestion)"
        
        Context: \(context)
        
        Please provide a brief, encouraging response (2-3 sentences) that:
        1. Addresses the specific suggestion they clicked
        2. Provides helpful guidance related to that suggestion
        3. Maintains a warm, supportive tone
        
        Keep it conversational and actionable.
        """
        
        conversationViewModel.sendMessage(contextualPrompt)
    }
    
    private func generateMainText() {
        let prompt = PromptGenerator.getPromptForContext(context, type: promptType)
        conversationViewModel.sendMessage(prompt)
    }
}

#Preview {
    VStack(spacing: 20) {
        // Exemple avec taille fixe (2 lignes)
        CrabbyThinks(
            bodyText: "You planned to tackle your FAFSA today. Just 5 minutes to feel lighter.",
            hasFixedSize: true,
            maxLines: 2
        )
        
        // Exemple avec taille variable (défaut 5 lignes max)
        CrabbyThinks(bodyText: "Time for a quick mindfulness break to reset your focus.")
        
        // Exemple avec plus de lignes en taille fixe
        CrabbyThinks(
            bodyText: "This is a longer text that might span multiple lines to demonstrate the fixed size behavior with truncation if needed.",
            hasFixedSize: true,
            maxLines: 3
        )
        
        // Exemple avec suggestions
        CrabbyThinks(
            bodyText: "You have some pending tasks that could use your attention right now.",
            hasFixedSize: true,
            maxLines: 4,
            suggestions: [
                "Call the FAFSA support line",
                "Read your health insurance email",
                "Start a laundry cycle"
            ],
           
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
} 
