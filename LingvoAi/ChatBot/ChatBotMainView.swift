
import SwiftUI
import OpenAI
import Firebase
import FirebaseAuth

class ChatController: ObservableObject {
    @Published var messages: [Message] = [
        .init(content: "Hello!", isUser: true),
        .init(content: "Hi! How can I help you?", isUser: false)
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
            model: .gpt3_5Turbo, messages: chatMessages
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
            VStack {
                Button {
                    do {
                        try FirebaseAuth.Auth.auth().signOut()
                        shouldShowLoginView = true
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(.black)
                }
                .navigationDestination(isPresented: $shouldShowLoginView) {
                    Login()
                }
                .padding(.leading, 350)
        
                
                
                ScrollView {
                    ForEach(chatController.messages) { message in
                        MessageView(message: message)
                            .padding(5)
                        
                    }
                }
                Divider()
                HStack {
                    TextField("Type a message...", text: self.$string, axis: .vertical)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                    
                    Button {
                        self.chatController
                            .sendNewMessage(content: string)
                        string = ""
                        
                        
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                .padding()
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
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.green)
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

