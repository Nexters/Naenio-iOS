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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = ProfileChangeViewModel()
    
    @State var showBottomSheet: Bool = false
    
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
                    
                    TextField("", text: $text)
                        .foregroundColor(.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 20)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white))
                    
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
        .addTrailingButton(title: "등록", disabled: text.isEmpty, action: {
            viewModel.submitProfileChangeRequest(nickname: text, index: profileImageIndex)
        })
        .hideLeadingButton(showBackButton == false)
        .onChange(of: viewModel.status) { value in // Observe status of API request
            switch value {
            case .done(_):
                userManager.updateNickName(text)
                userManager.updateProfileImageIndex(profileImageIndex)
                
                presentationMode.wrappedValue.dismiss()
            case .fail(with: let error):
                alertState = .errorHappend(error: error)
            default:
                break
            }
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
