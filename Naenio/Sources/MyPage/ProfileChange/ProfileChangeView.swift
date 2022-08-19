//
//  ChangeProfileView.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/15.
//

import SwiftUI
import Introspect

struct ProfileChangeView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel = ProfileChangeViewModel()
    
    @State var showBottomSheet: Bool = false
    
    @State var showAlert: Bool = false
    @State var alertType: AlertType = .none {
        didSet {
            switch alertType {
            case .none:
                showAlert = false
            default:
                showAlert = true
            }
        }
    }
    
    @State var profileImageIndex: Int = 0 // !!!: 나중에 유저 모델의 인덱스로 바뀌어야 함
    @State var text: String = ""
    
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
                ProfileImageSelectionSheetView(isPresented: $showBottomSheet, index: $profileImageIndex)
            }
        }
        .leadingButtonAction {
            if text.isEmpty == false {
                alertType = .warnBeforeExit
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .addTrailingButton(title: "등록", disabled: text.isEmpty, action: {
            viewModel.submitChangeNicknameRequest(text)
        })
        .hideLeadingButton(showBackButton == false)
        .onChange(of: viewModel.status) { value in // Observe status of API request
            print(value)
            switch value {
            case .done(_):
                presentationMode.wrappedValue.dismiss()
            case .fail(with: let error):
                alertType = .errorHappend(error: error)
            default:
                break
            }
        }
        .alert(isPresented: $showAlert) {   // Show the alert popup depending on the alert's type
            switch alertType {
            case .warnBeforeExit:
                return AlertType.getAlert(of: .warnBeforeExit, secondaryAction: { presentationMode.wrappedValue.dismiss() })
            default:
                return AlertType.getAlert(of: .none, secondaryAction: { presentationMode.wrappedValue.dismiss() })
            }
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
