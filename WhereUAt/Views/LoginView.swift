import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal, 15)
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut, value: configuration.isPressed)
    }
}

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("wya.")
                .font(.largeTitle)
                .bold()
            
            if authViewModel.isRegistering {
                TextField("Username", text: $username)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            TextField("Email", text: $email)
                .textFieldStyle(CustomTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(CustomTextFieldStyle())
            
            Button(action: {
                authViewModel.isRegistering ?
                    authViewModel.signUp(email: email, password: password, username: username) :
                    authViewModel.signIn(email: email, password: password)
            }) {
                Text(authViewModel.isRegistering ? "Register Account" : "Login")
                    .bold()
            }
            .buttonStyle(CustomButtonStyle())
            
            Button("or \(authViewModel.isRegistering ? "Login" : "Register")") {
                authViewModel.isRegistering.toggle()
            }
            .padding()
        }
        .padding()
        .alert(isPresented: $authViewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(authViewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
