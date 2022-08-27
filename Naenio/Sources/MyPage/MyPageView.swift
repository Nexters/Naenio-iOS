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
    
    private let personalCells: [NavigateCellData] = [
        NavigateCellData(name: "✏️ 작성한 댓글", destination: Text("dest"))
    ]
    
    private let businessCells: [NavigateCellData] = [
        NavigateCellData(name: "📢 공지사항", destination: NoticeView()),
        NavigateCellData(name: "👤 개발자 정보", destination: NoticeView()),
        NavigateCellData(name: "📱 버전 정보", destination: NoticeView())
    ]
    
    private let userCells: [NavigateCellData] = [
        NavigateCellData(name: "🔓 로그아웃", destination: Text("dest")),
        NavigateCellData(name: "️️🚪 회원탈퇴", destination: Text("dest"))
    ]
    
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
                        ForEach(Array(zip(personalCells.indices, personalCells)), id: \.1.id) { index, cell in
                            MyPageNavigationCell(name: cell.name, destination: cell.destination)
                            
                            if personalCells.count != 1 && index != personalCells.count - 1 {
                                CustomDivider()
                                    .padding(.horizontal, 12)
                            }
                        }
                    }
                    
                    MyPageSection {
                        ForEach(Array(zip(businessCells.indices, businessCells)), id: \.1.id) { index, cell in
                            MyPageNavigationCell(name: cell.name, destination: cell.destination)
                            
                            if businessCells.count != 1 && index != businessCells.count - 1 {
                                CustomDivider()
                            }
                        }
                        
                        CustomDivider()

                        MyPageLinkCell(name: "⁉️ 문의하기", url: URL(string: "https://forms.gle/KncRPJXwg69F5GpV7")!)
                    }
                    
                    MyPageSection {
                        ForEach(Array(zip(userCells.indices, userCells)), id: \.1.id) { index, cell in
                            MyPageNavigationCell(name: cell.name, destination: cell.destination)
                            
                            if userCells.count != 1 && index != userCells.count - 1 {
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
    var headerWithUserInformation: some View {
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
}

// Data model
fileprivate struct NavigateCellData<V: View>: Identifiable {
    let id = UUID()
    let name: String
    let destination: V
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
