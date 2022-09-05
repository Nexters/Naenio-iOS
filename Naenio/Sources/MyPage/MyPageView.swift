//
//  MyPageView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/31.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = MyPageViewModel()
    
    @AlertVariable var alertVariable: AlertType
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            if viewModel.status == .inProgress {
                LoadingIndicator()
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    headerWithUserInformation
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    
                    MyPageAuthCell(userManager.user?.authServiceType)
                        .cornerRadius(10)
                    
                    MyPageSection {
                        ForEach(PersonalCell.allCases, id: \.title) { cell in
                            MyPageNavigationCell(name: cell.title) {
                                cell.view().environmentObject(userManager)
                            }
                            
                            if cell.title != PersonalCell.allCases.last?.title {
                                CustomDivider()
                            }
                        }
                    }
                    
                    MyPageSection {
                        ForEach(BusinessCell.allCases, id: \.title) { cell in
                            MyPageNavigationCell(name: cell.title, destination: cell.view)
                            
                            CustomDivider()
                        }
                        
                        MyPageActionCell(name: "⁉️ 문의하기", action: {
                            let url = URL(string: "https://www.instagram.com/_naenio_/")!
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        })
                    }
                    
                    MyPageSection {
                        ForEach(AccountCell.allCases, id: \.title) { cell in
                            switch cell {
                            case .logout:
                                MyPageActionCell(name: cell.title, action: {
                                    alertVariable = .logout(secondaryAction: { viewModel.signOut() })
                                })
                            case .withdrawal:
                                MyPageActionCell(name: cell.title, action: {
                                    alertVariable = .withdrawal(secondaryAction: { viewModel.withdrawal() })
                                })
                            }
                            
                            if cell.title != AccountCell.allCases.last?.title {
                                CustomDivider()
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .alert(isPresented: $alertVariable) {
            alertVariable.getAlert()
        }
        .onChange(of: viewModel.status) { status in
            switch status {
            case .fail(let error):
                self.alertVariable = .errorHappend(error: error)
            case .done(let type):
                if type == .withdrawal {
                    viewModel.signOut()
                }
            default:
                break
            }
        }
    }
    
    var headerWithUserInformation: some View {
        HStack(spacing: 17) {
            ProfileImages.getImage(of: userManager.getProfileImagesIndex())
                .resizable()
                .scaledToFit()
                .frame(width: 61, height: 61)
            
            Text(userManager.getNickName())
                .font(.semoBold(size: 22))
            
            Spacer()
            
            NavigationLink(destination: LazyView(
                ProfileChangeView().environmentObject(userManager)
            )) {
                Text("edit")
                    .font(.semoBold(size: 15))
                    .frame(width: 58, height: 31)
                    .background(Color.card)
            }
            .cornerRadius(5)
        }
        .foregroundColor(.white)
    }
}

extension MyPageView {
    private enum AccountCell: CaseIterable {
        case logout
        case withdrawal
        
        var title: String {
            switch self {
            case .logout:
                return "🔓 로그아웃"
            case .withdrawal:
                return "🚪 회원탈퇴"
            }
        }
    }
    
    private enum BusinessCell: CaseIterable, NavigatableCell {
        case notice, developers, version
        
        var title: String {
            switch self {
            case .notice:
                return "📢 공지사항"
            case .developers:
                return "👤 개발자 정보"
            case .version:
                return "📱 버전 정보"
            }
        }
        
        @ViewBuilder func view() -> some View {
            switch self {
            case .notice:
                NoticeView()
            case .developers:
                DevelopersInfoView()
            case .version:
                VersionView()
            }
        }
    }
    
    private enum PersonalCell: CaseIterable, NavigatableCell {
        case comment
        
        var title: String {
            switch self {
            case .comment:
                return "✏️ 작성한 댓글"
            }
        }
        
        @ViewBuilder func view() -> some View {
            switch self {
            case .comment:
                MyCommentView()
            }
        }
    }
    
}

protocol NavigatableCell {
    associatedtype V: View

    var title: String { get }
    func view() -> V
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
