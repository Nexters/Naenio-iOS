//
//  ChangeProfileView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI
import Introspect
import AlertState

struct ProfileChangeView: View {
    typealias ProfileError = ProfileChangeViewModel.ProfileError
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = ProfileChangeViewModel()
    
    @State var showBottomSheet: Bool = false
    var isButtonDisabled: Bool {
        return !(
            self.profileImageIndex != userManager.getProfileImagesIndex() ||
            !self.text.isEmpty
            )
    }
    
    @AlertState<SystemAlert> var alertState
    
    @State var text: String = ""
    @State var profileImageIndex: Int = 0
    
    
    private let showBackButton: Bool
    
    var body: some View {
        CustomNavigationView(title: "프로필 변경") {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    // Profile image
                    ProfileImages.getImage(of: profileImageIndex)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 97, height: 97)
                        .overlay(editProfileImageButton, alignment: .bottomTrailing)
                        .padding(.top, 60)
                        .padding(.bottom, 42)
                    
                    WrappedTextView(
                        placeholder: userManager.getNickName(), content: $text, characterLimit: 10,
                        allowNewline: false, allowWhiteSpace: false, becomeFirstResponder: true
                    )
                    .frame(height: 20)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }
                    
//                    TextField(userManager.getNickName(), text: $text)
//                        .foregroundColor(.white)
//                        .padding(.vertical, 7)
//                        .padding(.horizontal, 20)
//                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white))
//                        .introspectTextField { textField in
//                            textField.becomeFirstResponder()
//                        }
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .foregroundColor(.white)
            }
            .halfSheet(isPresented: $showBottomSheet, ratio: 0.67, topBarTitle: "이미지 선택") {
                ProfileImageSelectionSheetView(isPresented: $showBottomSheet, profileImageIndex: $profileImageIndex)
            }
        }
        .leadingButtonAction {
            if text.isEmpty == false {
                alertState = .warnBeforeExit(secondaryAction: { presentationMode.wrappedValue.dismiss() })
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .addTrailingButton(title: "등록", disabled: isButtonDisabled, action: {
            viewModel.submitProfileChangeRequest(nickname: text, index: profileImageIndex)
        })
        .hideLeadingButton(showBackButton == false)
        .onChange(of: viewModel.status) { status in // Observe status of API request
            switch status {
            case .done(_):
                userManager.updateNickName(text)
                userManager.updateProfileImageIndex(profileImageIndex)
                
                presentationMode.wrappedValue.dismiss()
            case .fail(with: let error as ProfileError):
                alertState = .specificError(title: "확인해주세요", errorMessage: error.errorDescription)
            default:
                break
            }
            viewModel.status = .waiting
        }
        .showAlert(with: $alertState)
        .onAppear {
            self.profileImageIndex = userManager.getProfileImagesIndex()
        }
        .navigationBarHidden(true)
    }
    
    var editProfileImageButton: some View {
        Button(action: {
            showBottomSheet = true
            UIApplication.shared.endEditing()
        }) {
            Image("pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
    }
    
    init(showBackButton: Bool = true) {
        self.showBackButton = showBackButton
    }
}
