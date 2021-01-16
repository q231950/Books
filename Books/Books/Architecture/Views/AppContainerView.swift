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

struct AppContainerView : View {

    @ObservedObject private var viewModel = AppContainerViewModel()

    var body: some View {
        viewForState(viewModel.authenticationState)
            .onAppear {
                AppEnvironment.current.authenticationInteractor.attemptAutomaticAuthentication()
            }
    }

    private func viewForState(_ state: AuthenticationState) -> some View {
        switch state {
        case .authenticating:
            return AnyView(ActivityIndicator(isAnimating: .constant(true), style: .medium))
        case .authenticationComplete(.authenticated):
            return AnyView(SignedInContainerView())
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
        case .idle:
            return AnyView(Text("AppContainerView: .idle"))
        }
    }

    func signInView() -> some View {
        SignInView(viewModel: SignInViewModel(), appContainerViewModel: viewModel)
    }
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        let credentialsProvider = AccountViewModel()
//        let authenticationManager = AuthenticationManager(accountStore: AccountStore())
//        let viewModel = AppContainerViewModel(authenticationManager: authenticationManager, credentialsProvider: credentialsProvider)
//        let interactor = AppContainerInteractor()
//        return ContentView(viewModel: viewModel, interactor: interactor)
//            .preferredColorScheme(.dark)
//    }
//}
//#endif
//
