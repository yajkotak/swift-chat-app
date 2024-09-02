import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                HStack {
                    if message.isIncoming {
                        Spacer()
                    }
                    Text(message.text)
                        .padding()
                        .background(message.isIncoming ? Color.gray.opacity(0.2) : Color.blue)
                        .foregroundColor(message.isIncoming ? .black : .white)
                        .cornerRadius(10)
                    if !message.isIncoming {
                        Spacer()
                    }
                }
            }
            
            HStack {
                TextField("Enter your message", text: $viewModel.newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    viewModel.sendMessage()
                }
                .padding(.leading, 10)
            }
            .padding()
        }
        .navigationTitle("Chat")
        .onAppear {
            viewModel.listenForMessages()
        }
    }
}

#Preview {
    ContentView()
}
