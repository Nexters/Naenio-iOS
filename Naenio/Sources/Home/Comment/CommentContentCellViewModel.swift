//
//  CommentContentCellViewModel.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/31.
//

import SwiftUI
import RxSwift

class CommentContentCellViewModel: ObservableObject {
    @Published var status: NetworkStatus<WorkType> = .waiting
    
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler(qos: .utility)
    
    func requestLike(isCancel: Bool, commentId: Int) {
        status = .inProgress
        
        let job: NaenioAPI = isCancel ? .deleteCommentLike(commentId) : .postCommentLike(commentId)
        job.request()
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let self = self else { return }
                    print("Success requestComments")
                    
                    self.status = .done(result: .like)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    func delete(commentId: Int) {
        NaenioAPI.deleteComment(commentId).request()
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.status = .done(result: .delete)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    func report(authorId: Int, type: CommentType) {
        status = .inProgress
        
        ReportManager.report(authorId: authorId, type: type)
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let self = self else { return }
                    self.status = .done(result: .report)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
    
    func block(authorId: Int) {
        status = .inProgress
        
        UserBlockManager.block(authorId)
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] _ in
                    guard let self = self else { return }
                    self.status = .done(result: .block)
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                })
            .disposed(by: bag)
    }
}

extension CommentContentCellViewModel {
    enum WorkType {
        case like
        case report
        case block
        case delete
    }
}
