//
//  CommentViewModel.swift
//  Naenio
//
//  Created by 이영빈 on 2022/08/12.
//

import SwiftUI
import RxSwift

class CommentViewModel: ObservableObject {
    typealias Comment = CommentModel.Comment
    typealias Author = CommentModel.Comment.Author
    
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler(qos: .utility)
    
    @Published var comments: [Comment]
    @Published var totalCommentCount: Int = 0 // 얘를 stored로 유지해야 하는 이유: 페이징이 안 되어있을 때 가지고 있는 코멘트 카운트만 표시하는 문제가 있다,
    @Published var status: NetworkStatus<WorkType> = .waiting
    
    var pageSize = 10
    
    @Published var isFirstRequest: Bool = true

    init() {
        self.comments = []
    }
    
    func registerComment(_ content: String, postId: Int?) {
        guard let postId = postId else {
            return
        }
        
        status = .inProgress
        let commentRequestModel = CommentPostRequestModel(parentID: postId, parentType: CommentType.post.rawValue, content: content)
        
        RequestService<CommentPostResponseModel>.request(api: .postComment(commentRequestModel))
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] comment in
                    guard let self = self else { return }
                    let newComment = self.transferToCommentModel(comment)
                    
//                    self.totalCommentCount += 1
                    withAnimation {
                        self.comments.insert(newComment, at: 0)
                    }
                    
                    self.status = .done(result: .register)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    func requestComments(postId: Int, lastCommentId: Int?) {
        if lastCommentId == nil {
            status = .inProgress
        }
        
        let commentListRequestModel = CommentListRequestModel(size: self.pageSize, lastCommentId: lastCommentId)
        RequestService<CommentModel>.request(api: .getComment(postId: postId, model: commentListRequestModel)) // FIXME: 두 변수 한 모델로 합칠 것
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] commentInfo in
                    guard let self = self else { return }
                    
                    self.totalCommentCount = commentInfo.totalCommentCount
                    
                    if lastCommentId == nil {
                        self.comments = commentInfo.comments
                    } else {
                        self.comments.append(contentsOf: commentInfo.comments)
                    }
                
                    self.status = .done(result: .requestComments)
                }, onFailure: { [weak self] error in
                    
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    func delete(at index: Int) {
        _ = withAnimation {
            comments.remove(at: index)
        }
        
        totalCommentCount -= 1
    }
}

extension CommentViewModel {
    func transferToCommentModel(_ comment: CommentPostResponseModel) -> Comment {
        let author = Comment.Author(id: comment.memberId, nickname: UserManager.shared.getNickName(), profileImageIndex: UserManager.shared.getProfileImagesIndex()) // FIXME: to extension later
        return Comment(id: comment.id, author: author, content: comment.content, createdDatetime: comment.createdDateTime, likeCount: 0, isLiked: false, repliesCount: 0)
    }
    
    enum WorkType {
        case register
        case requestComments
    }
}
