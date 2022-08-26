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
    @Published var commentRepliesCount: Int?
    @Published var replies = [Comment]()
    @Published var status = Status.waiting
    
    func registerReply(_ content: String, postId: Int?) {
        guard let postId = postId else {
            return
        }
        
        status = .loading
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
                    
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed registerComment")
                })
            .disposed(by: bag)
    }
    
    func transferToCommentModel(from comment: CommentPostResponseModel) -> Comment {
        let author = Comment.Author(id: comment.memberId, nickname: UserManager.shared.getNickName(), profileImageIndex: UserManager.shared.getProfileImagesIndex())
        return Comment(id: comment.id, author: author, content: comment.content, createdDatetime: comment.createdDateTime, likeCount: 0, isLiked: false, repliesCount: 0)
    }
    
    func transferToCommentModel(from replies: [CommentRepliesResponseModel.CommentRepliesListModel]) -> [Comment] {
        var result: [Comment] = [ ]
        replies.forEach { reply in
            let author = Comment.Author(id: reply.author.id, nickname: reply.author.nickname, profileImageIndex: reply.author.profileImageIndex)
            let newReply = Comment(id: reply.id, author: author, content: reply.content, createdDatetime: reply.createdDatetime, likeCount: reply.likeCount, isLiked: reply.isLiked, repliesCount: 0)
            result.append(newReply)
        }
        
        return result
    }
    
    func requestCommentReplies(postId: Int?, isFirstRequest: Bool = true) {
        status = .loading
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
                    print("Success requestComments")
                    
                    self.commentRepliesCount = replies.commentReplies.count
                    
                    if isFirstRequest {
                        self.replies = self.transferToCommentModel(from: replies.commentReplies)
                    } else {
                        self.replies.append(contentsOf: self.transferToCommentModel(from: replies.commentReplies))
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
    
    // !!!: Test
    func testRegisterReply(_ content: String, parentID: Int) {
        status = .loading
        let commentRequestModel = CommentPostRequestModel(parentID: parentID, parentType: CommentType.comment.rawValue, content: content)
        
        print(content)
        
        registerNewComment(commentRequestModel)
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] newComment in
                    guard let self = self else { return }
                    print(newComment)
                    withAnimation {
                        self.replies.insert(newComment, at: 0)
                    }
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed registerComment")
                })
            .disposed(by: bag)
    }
    
    // !!!: Test
    func testRequestCommentReplies() {
        status = .loading
        
        // ???: 얘는 잘 하면 추상화 가능할 수도(HomeViewModel이랑 똑같음 구조는)
        getCommentDisposable()
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] commentInfo in
                    guard let self = self else { return }
                    print("Success requestComments")
                    
                    self.commentRepliesCount = commentInfo.totalCommentCount
                    self.replies.append(contentsOf: commentInfo.comments)
                    
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestComments")
                })
            .disposed(by: bag)
    }
}

extension CommentRepliesViewModel {
    enum Status: Equatable {
        static func == (lhs: CommentRepliesViewModel.Status, rhs: CommentRepliesViewModel.Status) -> Bool {
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

// !!!: Test
extension CommentRepliesViewModel {
    private func getCommentDisposable() -> Single<CommentModel> {
        let commentInfo = MockCommentGenertor.generate()
        
        return Observable.of(commentInfo).asSingle().delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    private func registerNewComment(_ commentRequest: CommentPostRequestModel) -> Single<Comment> {
        let mockComment = MockCommentGenertor.generate(with: commentRequest)
        let observable = Observable.just(mockComment)
        
        return observable.asSingle().delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
