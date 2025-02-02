import SwiftUI
import FacebookCore

struct ProfileView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var userName: String = ""
    @State private var isEditing: Bool = false
    @State private var showNotification: Bool = false
    @State private var notificationMessage: String = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                userHeader
                    .padding(.top)
                Text("Nickname")
                    .font(.body)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    TextField("Username", text: $userName)
                        .disabled(!isEditing)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isEditing ? Color.blue : Color.gray, lineWidth: 1)
                        )
                        .foregroundColor(isEditing ? .black : .gray)

                    Button(action: {
                        if isEditing {
                            // Save action
                            viewModel.send(.setUserName(userName))
                            showNotification(message: "Nickname saved successfully!")
                        }
                        isEditing.toggle()
                    }) {
                        Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(isEditing ? .green : .black)
                            .padding(.horizontal, 8)
                    }
                }
                VStack(alignment: .leading) {
                    FacebookLoginButton()
                        .frame(height: 45)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.vertical)

                HomeSkinBox(homeViewModel: viewModel)
                    .onChange(of: viewModel.state.user.activeSkin?.name) { _ in
                        showNotification(message: "Skin changed successfully!")
                    }
                    .padding(.vertical)
                
                if userName == "Admin" {
                    Button(action: {
                        viewModel.send(.resetUserSkins)
                        showNotification(message: "Skins reset successfully!")
                    }) {
                        Text("Reset User Skins")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button("Add Coins") {
                        viewModel.send(.addCoins(100))
                        showNotification(message: "100 coins added!")
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }

                Spacer()
            }
            .padding()
            .background(Color.backgroundColor)
            .overlay(
                VStack {
                    Spacer()
                    if showNotification {
                        Text(notificationMessage)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(10)
                            .transition(.opacity)
                            .padding(.bottom, 50)
                    }
                }
            )
        }
        .onAppear {
            setupFacebookObserver()
            userName = viewModel.state.user.name
            viewModel.send(.didAppear)

        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .AccessTokenDidChange, object: nil)
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Profile")
        .toolbarBackground(Color.toolbarColor)
        .toolbarBackground(.visible)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackBarButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                ToolbarCoins(homeViewModel: viewModel)
            }
        }
    }

    // MARK: - Setup Facebook Observer
    private func setupFacebookObserver() {
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: .main) { _ in
            if let token = AccessToken.current, !token.isExpired {
                viewModel.send(.setFacebookId)
                viewModel.send(.saveUserToFirestore)
                viewModel.send(.fetchFirestoreUser)
                FacebookLoginButton.fetchUserProfile()
            }
        }
    }

    // Function to show a notification
    private func showNotification(message: String) {
        notificationMessage = message
        withAnimation {
            showNotification = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showNotification = false
            }
        }
    }
    
    // MARK: - User Header
    private var userHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Manage Your Profile")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Divider()
                .background(Color.primary.opacity(0.3))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
