import SwiftUI

struct GithubTokenView: View {
    let gitHubAPI: GitHubAPIWrapper
    @State private var token: String = ""
    @State private var isSaved = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("GitHub Token")) {
                    SecureField("Enter GitHub Personal Access Token", text: $token)
                    
                    Button(action: saveToken) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Save Token")
                        }
                        .foregroundColor(.white)
                    }
                    .listRowBackground(Color.blue)
                    
                    if !token.isEmpty {
                        Button(role: .destructive, action: deleteToken) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Token")
                            }
                        }
                    }
                }
                
                if isSaved {
                    Section {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Token saved successfully")
                                .foregroundColor(.green)
                        }
                    }
                }
                
                if let errorMessage {
                    Section {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("GitHub Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear(perform: loadToken)
        }
    }
    
    private func loadToken() {
        do {
            token = try gitHubAPI.getToken() ?? ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func saveToken() {
        guard !token.isEmpty else {
            errorMessage = "Please enter a token"
            return
        }
        
        do {
            try gitHubAPI.saveToken(token)
            isSaved = true
            errorMessage = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isSaved = false
            }
        } catch {
            errorMessage = error.localizedDescription
            isSaved = false
        }
    }
    
    private func deleteToken() {
        do {
            try gitHubAPI.deleteToken()
            token = ""
            isSaved = true
            errorMessage = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isSaved = false
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    GithubTokenView(gitHubAPI: GitHubAPIWrapper())
}
