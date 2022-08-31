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
    
    private var pageSize = 10
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler(qos: .utility)
    
    @Published var comments = [Comment]()
    @Published var replies = [Comment]()
    @Published var status = Status.waiting
    @Published var lastCommentId: Int?
    
    @Published var isFirstRequest: Bool = true

    func registerComment(_ content: String, postId: Int?) {
        guard let postId = postId else {
            return
        }
        
        status = .loading
        let commentRequestModel = CommentPostRequestModel(parentID: postId, parentType: CommentType.post.rawValue, content: content)
        
        RequestService<CommentPostResponseModel>.request(api: .postComment(commentRequestModel))
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] comment in
                    guard let self = self else { return }
                    let newComment = self.transferToCommentModel(comment)
                    
                    print("new comment", newComment)
                    self.comments.insert(newComment, at: 0)
                    
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed registerComment")
                })
            .disposed(by: bag)
    }
    
    func requestComments(postId: Int?, isFirstRequest: Bool = true) {
        status = .loading
        guard let postID = postId else {
            return
        }
        
        let commentListRequestModel = CommentListRequestModel(size: pageSize, lastCommentId: isFirstRequest ? nil : lastCommentId)
        RequestService<CommentModel>.request(api: .getComment(postId: postID, model: commentListRequestModel))
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] commentInfo in
                    guard let self = self else { return }
                    print("Success requestComments")
                    
                    if isFirstRequest {
                        self.comments = commentInfo.comments
                    } else {
                        self.comments.append(contentsOf: commentInfo.comments)
                    }
                    
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestComments")
                })
            .disposed(by: bag)
    }
        
    func transferToCommentModel(_ comment: CommentPostResponseModel) -> Comment {
        let author = Comment.Author(id: comment.memberId, nickname: UserManager.shared.getNickName(), profileImageIndex: UserManager.shared.getProfileImagesIndex()) // FIXME: to extension later
        return Comment(id: comment.id, author: author, content: comment.content, createdDatetime: comment.createdDateTime, likeCount: 0, isLiked: false, repliesCount: 0)
    }
}

extension CommentViewModel {
    enum Status: Equatable {
        static func == (lhs: CommentViewModel.Status, rhs: CommentViewModel.Status) -> Bool {
            return lhs.description == rhs.description
        }
        
        case waiting
        case loading
        case done
        case fail(with: Error)
        
        var description: String {
            switch self {
            case .waiting:
                return "Waiting"
            case .loading:
                return "Loading comments"
            case .done:
                return "Successfully done"
            case .fail(let error):
                return "Failed with error: \(error.localizedDescription)"
            }
        }
    }
}
