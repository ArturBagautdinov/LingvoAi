
import SwiftUI
import OpenAI
import Firebase
import FirebaseAuth

class ChatController: ObservableObject {
    @Published var messages: [Message] = [
        .init(content: "Hi, I am your personal assistant! How can I help you?", isUser: false)
    ]
    
    let openAI = OpenAI(apiToken: "")
    
    func sendNewMessage(content: String) {
        guard !content.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let chatMessages = self.messages.map { message in
            Chat(role: message.isUser ? .user : .assistant,
                 content: message.content)
        }
        
        let query = ChatQuery(
            model: .gpt4_0613, messages: chatMessages
        )
        
        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else { return }
                let messageContent = choice.message.content ?? ""
                
                DispatchQueue.main.async {
                    self.messages.append(Message(content: messageContent, isUser: false))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.messages.append(Message(
                        content: "Error: \(error.localizedDescription)",
                        isUser: false
                    ))
                }
            }
        }
    }
}

struct Message: Identifiable {
    var id: UUID = UUID()
    var content: String
    let isUser: Bool
}

struct ChatBotMainView: View {
    @StateObject private var chatController = ChatController()
    @State var string: String = ""
    @State private var shouldShowLoginView = false
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundGradient()
                
                VStack(spacing: 0) {
                    ZStack {
                        GradientHeader(header: "LingvoChat")
                    }
                    .padding(.top, 5)
                    .padding(.horizontal)
                    
                    ScrollView {
                        ForEach(chatController.messages) { message in
                            MessageView(message: message)
                                .padding(15)
                                .id(message.id)
                            
                        }
                    }
                    Divider()
                    HStack {
                        TextField("Type a message...", text: self.$string, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        
                        Button {
                            self.chatController
                                .sendNewMessage(content: string)
                            string = ""
                            
                            
                        } label: {
                            Image(systemName: "paperplane")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    
                }
            }
        }
    }
}

struct MessageView: View {
    var message: Message
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    Spacer()
                }
            }
        }
    }
}
#Preview {
    ChatBotMainView()
}

