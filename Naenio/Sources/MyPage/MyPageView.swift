//
//  MyPageView.swift
//  Naenio
//
//  Created by 조윤영 on 2022/07/31.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var userManger: UserManager
    @ObservedObject var viewModel = MyPageViewModel()
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    headerWithUserInformation
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    
                    MyPageAuthCell(authType: .kakao)
                        .cornerRadius(10)
                    
                    MyPageSection {
                        ForEach(PersonalCell.allCases, id: \.title) { cell in
                            MyPageNavigationCell(name: cell.title, destination: cell.view)
                            
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
                        
                        MyPageLinkCell(name: "⁉️ 문의하기", url: URL(string: "https://forms.gle/KncRPJXwg69F5GpV7")!)
                    }
                    
                    MyPageSection {
                        ForEach(AccountCell.allCases, id: \.title) { cell in
                            MyPageNavigationCell(name: cell.title, destination: cell.view)
                            
                            if cell.title != AccountCell.allCases.last?.title {
                                CustomDivider()
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
        }
    }
}

// Components
extension MyPageView {
    private var headerWithUserInformation: some View {
        HStack(spacing: 17) {
            viewModel.profileImage
                .resizable()
                .scaledToFit()
                .frame(width: 61, height: 61)
            
            Text(viewModel.nickname)
                .font(.semoBold(size: 22))
            
            Spacer()
            
            NavigationLink(destination: LazyView(
                ProfileChangeView().environmentObject(userManger)
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
                DevelopersView()
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
                Text("SS")
            }
        }
    }
    
    private enum AccountCell: CaseIterable, NavigatableCell {
        case logout, withdrawal
        
        var title: String {
            switch self {
            case .logout:
                return "🔓 로그아웃"
            case .withdrawal:
                return "🚪 회원탈퇴"
            }
        }
        
        @ViewBuilder func view() -> some View {
            switch self {
            case .logout:
                Text("logout")
            case .withdrawal:
                Text("witherawal")
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
