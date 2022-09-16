//
//  NewRandomThemeView.swift
//  Naenio
//
//  Created by 이영빈 on 2022/09/14.
//

import SwiftUI
import AlertState

struct NewRandomThemeView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = NewRandomThemeViewModel()
    
    @State var mockPost = MockPostGenerator.generate(sortType: .participated)
    @State var attempts = 0

    @AlertState<SystemAlert> var alertState

    let theme: ThemeType
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(gradient: Gradient(colors: theme.data.backgroundColorList),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            FullView(post: $viewModel.post,
                     showBackground: false,
                     navigationTitle: theme.data.title,
                     contentColor: .white)
                .environmentObject(userManager)
                .modifier(Shake(animatableData: CGFloat(attempts)))
            
            updateRandomPostButton
                .disabled(viewModel.status == .inProgress)
                .padding()
        }
        .showAlert(with: $alertState)
        .onChange(of: viewModel.status) { status in
            switch status {
            case .fail(with: let error):
                alertState = .networkErrorHappend(error: error)
            default:
                break
            }
        }
    }
    
    
    var updateRandomPostButton: some View {
        Button(action: {
            // MARK: 굴러가는 느낌의 haptic 적용을 위해 error type 채택. 실제 기능 상의 error를 뜻하는 바는 아님.
            // TODO: Custom haptic 적용이 가능한지 확인 필요
            HapticManager.shared.notification(type: .error)
            viewModel.requestRandomThemePosts()
            withAnimation(.default) {
                self.attempts += 1
            }}
        ) {
            Image("random_button")
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
        }
        .onShake {
            HapticManager.shared.notification(type: .error)
            viewModel.requestRandomThemePosts()
            withAnimation(.default) {
                self.attempts += 1
            }
        }
    }
}
