//
//  CommentRepliesViewModel.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/13.
//

import SwiftUI
import RxSwift

class CommentRepliesViewModel: ObservableObject {
    
    typealias Comment = CommentModel.Comment
    typealias Author = CommentModel.Comment.Author
    
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler(qos: .utility)
    
    private let pagingSize = 10
    @Published var replies = [Comment]()
    @Published var status: NetworkStatus<WorkType> = .waiting
    
    func registerReply(_ content: String, postId: Int?) {
        guard let postId = postId else {
            return
        }
        
        status = .inProgress
        let commentRequestModel = CommentPostRequestModel(parentID: postId, parentType: CommentType.comment.rawValue, content: content)
        
        RequestService<CommentPostResponseModel>.request(api: .postComment(commentRequestModel))
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] reply in
                    guard let self = self else { return }
                    
                    withAnimation {
                        let newReply = self.transferToCommentModel(from: reply)
                        self.replies.insert(newReply, at: 0)
                    }
                    
                    self.status = .done(result: .registerComment)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    func requestCommentReplies(postId: Int?, isFirstRequest: Bool = true) {
        status = .inProgress
        guard let postId = postId else {
            return
        }
        
        let commentRepliesRequestModel = CommentRepliesRequestModel(size: pagingSize, lastCommentId: nil)
        RequestService<CommentRepliesResponseModel>.request(api: .getCommentReplies(postId: postId, model: commentRepliesRequestModel))
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] replies in
                    guard let self = self else { return }
                    
                    if isFirstRequest {
                        self.replies = self.transferToCommentModel(from: replies.commentReplies)
                    } else {
                        self.replies.append(contentsOf: self.transferToCommentModel(from: replies.commentReplies))
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
            replies.remove(at: index)
        }
    }
}

extension CommentRepliesViewModel {
    private func transferToCommentModel(from comment: CommentPostResponseModel) -> Comment {
        let author = Comment.Author(id: comment.memberId, nickname: UserManager.shared.getNickName(), profileImageIndex: UserManager.shared.getProfileImagesIndex())
        return Comment(id: comment.id, author: author, content: comment.content, createdDatetime: comment.createdDateTime, likeCount: 0, isLiked: false, repliesCount: 0)
    }
    
    private func transferToCommentModel(from replies: [CommentRepliesResponseModel.CommentRepliesListModel]) -> [Comment] {
        var result: [Comment] = [ ]
        replies.forEach { reply in
            let author = Comment.Author(id: reply.author.id, nickname: reply.author.nickname, profileImageIndex: reply.author.profileImageIndex)
            let newReply = Comment(id: reply.id, author: author, content: reply.content, createdDatetime: reply.createdDatetime, likeCount: reply.likeCount, isLiked: reply.isLiked, repliesCount: 0)
            result.append(newReply)
        }
        
        return result
    }
    
    enum WorkType {
        case requestComments
        case registerComment
    }
}
