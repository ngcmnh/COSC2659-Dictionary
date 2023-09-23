/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Phan Nhat Minh
 ID: S3904422
 Created date: 16/09/2023
 Last modified: 19/09/2023
 Acknowledgement:
 https://youtu.be/0ytO3wCRKZU?si=ZgDxBYqK_RAJ_pJ0
 https://www.appicon.co/#image-sets
 */

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    var body: some View {
        // MARK: -Redirect Main View
        if isActive {
            LoginView()
        } else {
            VStack {
                VStack {
                    // MARK: -Icon App
                    Image("SplashScreenIcon")
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                    // MARK: -Name App
                    Text("23:AM Dictionary")
                        .font(Font.custom("Baskerville-Bold", size: 26))
                        .foregroundColor(Color("Text"))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                // MARK: -Display Duration
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
