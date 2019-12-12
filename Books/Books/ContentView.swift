//
//  ContentView.swift
//  Books
//
//  Created by Martin Kim Dung-Pham on 08.06.19.
//  Copyright © 2019 Martin Kim Dung-Pham. All rights reserved.
//

import SwiftUI
import LibraryCore
import Combine

struct ContentView : View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    var body: some View {
        view(for: authenticationViewModel.authenticated).onAppear() {
            self.authenticationViewModel.attemptAutomaticAuthentication()
        }
    }

    func view(for state: AuthenticationState) -> AnyView {
        switch state {
        case .authenticating:
            return AnyView(ActivityIndicator(isAnimating: .constant(true), style: .medium))
        case .authenticationComplete(.authenticated):
            return AnyView(SignedInContainerView(authentication: authenticationViewModel)
                .padding(EdgeInsets(top: CGFloat(0), leading: CGFloat(10), bottom: CGFloat(0), trailing: CGFloat(10))))
        case .authenticationComplete(.manualAuthenticationFailed):
            return AnyView(signInView().alert(isPresented: .constant(true)) {
                Alert(title: Text("Invalid Credentials"), message: Text("The username and password do not match. Have you recently changed your password?"), dismissButton: .default(Text("Ok")))
                })
        case .authenticationComplete(.automaticAuthenticationFailed):
            return AnyView(signInView())
        case .authenticationError(let error):
            return AnyView(signInView().alert(isPresented: .constant(true)) {
                    Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("Ok")))
                })
        case .authenticationComplete(.signOutSucceeded):
            return AnyView(signInView().alert(isPresented: .constant(true)) {
                Alert(title: Text("Signed Out"), message: Text("You are now signed out"), dismissButton: .default(Text("Ok")))
            })
        case .authenticationComplete(.missingUsername):
            return AnyView(signInView().alert(isPresented: .constant(true)) {
                Alert(title: Text("Error"), message: Text("Please enter a username"), dismissButton: .default(Text("Ok")))
            })
        case .authenticationComplete(.missingPassword):
            return AnyView(signInView().alert(isPresented: .constant(true)) {
                Alert(title: Text("Error"), message: Text("Please enter a password"), dismissButton: .default(Text("Ok")))
            })
        }

    }

    func signInView() -> some View {
        return SignInView(authentication: authenticationViewModel)
            .padding(EdgeInsets(top: CGFloat(0), leading: CGFloat(10), bottom: CGFloat(0), trailing: CGFloat(10)))
    }
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        let accountViewModel = AccountViewModel(account: Account())
        let authenticationViewModel = AuthenticationViewModel(accountViewModel: accountViewModel)
        return ContentView(authenticationViewModel: authenticationViewModel)
    }
}
#endif

