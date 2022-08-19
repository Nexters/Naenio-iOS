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
    
    @Published var commentsCount: Int?
    @Published var comments = [Comment]()
    @Published var replies = [Comment]()
    @Published var status = Status.waiting
    @Published var lastCommentId: Int?
    
    @Published var postId: Int = 0
    @Published var isFirstRequest: Bool = true
    
    func transferToCommentModel(_ comment: CommentPostResponseModel) -> Comment {
        let author = Comment.Author(id: comment.memberId, nickname: UserManager.shared.getNickName(), profileImageIndex: UserManager.shared.getProfileImagesIndex())
        return Comment(id: comment.id, author: author, content: comment.content, createdDatetime: comment.createdDateTime, likeCount: 0, isLiked: false, repliesCount: 0)
    }

    func registerComment(_ content: String, parentID: Int, type: CommentType) {
        status = .loading
        let commentRequestModel = CommentPostRequestModel(parentID: parentID, parentType: type.rawValue, content: content)
        
        RequestService<CommentPostResponseModel>.request(api: .postComment(commentRequestModel))
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] comment in
                    guard let self = self else { return }
                    
                    withAnimation {
                        let newComment = self.transferToCommentModel(comment)
                        self.comments.insert(newComment, at: 0)
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
    
    @objc func requestcommentAction() {
        self.requestComments(postId: postId, isFirstRequest: isFirstRequest)
    }
    func requestComments(postId: Int, isFirstRequest: Bool) {
        status = .loading
        
        let commentListRequestModel = CommentListRequestModel(size: pageSize, lastCommentId: isFirstRequest ? nil : lastCommentId)
        RequestService<CommentModel>.request(api: .getComment(postId: postId, model: commentListRequestModel))
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] commentInfo in
                    guard let self = self else { return }
                    print("Success requestComments")
                    
                    self.commentsCount = commentInfo.totalCommentCount
                    
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
    
    // !!!: Test
    func testRequestComments() {
        status = .loading
        
        // ???: 얘는 잘 하면 추상화 가능할 수도(HomeViewModel이랑 똑같음 구조는)
        getCommentDisposable()
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] commentInfo in
                    guard let self = self else { return }
                    print("Success requestComments")
                    
                    self.commentsCount = commentInfo.totalCommentCount
                    self.comments.append(contentsOf: commentInfo.comments)
                    
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
    func testRegisterComment(_ content: String, parentID: Int) {
        status = .loading
        let commentPostRequestModel = CommentPostRequestModel(parentID: parentID, parentType: CommentType.post.rawValue, content: content)
        
        registerNewComment(commentPostRequestModel)
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] newComment in
                    guard let self = self else { return }
                    
                    withAnimation {
                        self.comments.insert(newComment, at: 0)
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

// !!!: Test
extension CommentViewModel {
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
