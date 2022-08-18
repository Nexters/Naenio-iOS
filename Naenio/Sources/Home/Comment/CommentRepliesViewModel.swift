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
    let parentID = UUID().uuidString.hashValue // TODO: 나중에 밖에서 받아와야 함

    @Published var commentsCount: Int?
    @Published var replies = [Comment]()
    @Published var status = Status.waiting
    
    // !!!: Test
    func registerComment(_ content: String, parentID: Int) {
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
    func requestComments() {
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
