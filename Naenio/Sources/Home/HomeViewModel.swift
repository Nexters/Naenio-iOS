//
import SwiftUI
import RxSwift

class HomeViewModel: ObservableObject {
    // Published vars
    @Published var sortType: SortType?
    @Published var posts: [Post]
    @Published var status: Status = .waiting
    @Published var lastPostId: Int?
    
    // vars and lets
    private let pagingSize = 10
    private var bag = DisposeBag()
    private let serialQueue = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    
    func register(postRequesInformation: PostRequestInformation) {
        status = .loading(reason: "sameCategoryPosts")
        
        RequestService<PostResponseModel>.request(api: .postPost(postRequesInformation))
            .subscribe(on: serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] post in
                    guard let self = self else { return }
                    
                    let author = Author(
                        id: post.memberId,
                        nickname: UserManager.shared.getNickName(),
                        profileImageIndex: UserManager.shared.getProfileImagesIndex()
                    )
                    let nextChoices = self.transferToChoiceModel(from: post.choices)
                    let newPost = Post(id: post.id,
                                       author: author,
                                       voteCount: 0,
                                       title: post.title,
                                       content: post.content ?? "",
                                       choices: nextChoices, commentCount: 0)
                    withAnimation {
                        self.posts.insert(newPost, at: 0)
                    }
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestPosts")
                })
            .disposed(by: bag)
    }
    
    @objc func requestPosts() {
        bag = DisposeBag()
        status = .loading(reason: "differentCategoryPosts")
        
        let feedRequestInformation: FeedRequestInformation = FeedRequestInformation(size: pagingSize, lastPostId: nil, sortType: sortType?.rawValue)
        
        RequestService<FeedResponseModel>.request(api: .getFeed(feedRequestInformation))
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] newFeed in
                    guard let self = self else { return }
                    
                    print("Success requestPosts")
                    let posts = self.transferToPostModel(from: newFeed)
                    self.posts = posts
                    self.changeLastPostId()
                    
                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestPosts")
                })
            .disposed(by: bag)
    }
    
    func requestMorePosts() {
        bag = DisposeBag()
        status = .loading(reason: "sameCategoryPosts")
        
        let feedRequestInformation: FeedRequestInformation = FeedRequestInformation(size: pagingSize, lastPostId: self.lastPostId, sortType: sortType?.rawValue)

        RequestService<FeedResponseModel>.request(api: .getFeed(feedRequestInformation))
            .subscribe(on: self.serialQueue)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] feed in
                    guard let self = self else { return }
                    
                    print("Success requestPosts")
                    let newPost = self.transferToPostModel(from: feed)
                    self.posts.append(contentsOf: newPost)
                    self.changeLastPostId()

                    self.status = .done
                }, onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    self.status = .fail(with: error)
                }, onDisposed: {
                    print("Disposed requestMorePosts")
                })
            .disposed(by: bag)

    }
    
    func changeLastPostId() {
        if !self.posts.isEmpty {
            self.lastPostId = self.posts[self.posts.count - 1].id
        }
    }

    init( ) {
        self.posts = []
        self.requestPosts()
    }
}

extension HomeViewModel {
    private func voteTotalCount(choices: [Choice]) -> Int {
        guard choices.count == 2 else { return 0 }
        
        return choices[0].voteCount + choices[1].voteCount
    }
    
    private func transferToPostModel(from feed: FeedResponseModel) -> [Post] {
        var resultPosts: [Post] = [ ]
        feed.posts.forEach { post in
            let voteTotalCount = voteTotalCount(choices: post.choices)
            let newPost = Post(id: post.id, author: post.author, voteCount: voteTotalCount, title: post.title, content: post.content, choices: post.choices, commentCount: post.commentCount)
            
            resultPosts.append(newPost)
        }
        
        return resultPosts
    }
    
    private func transferToChoiceModel(from choices: [PostResponseModel.Choice]) -> [Choice] {
        var resultChoices: [Choice] = [ ]
        choices.forEach { choice in
            let newChoice = Choice(id: choice.id, sequence: choice.sequence, name: choice.name, isVoted: false, voteCount: 0)
            resultChoices.append(newChoice)
        }
        
        return resultChoices
    }
}

extension HomeViewModel {
    enum Status: Equatable {
        static func == (lhs: HomeViewModel.Status, rhs: HomeViewModel.Status) -> Bool {
            return lhs.description == rhs.description
        }
        
        case waiting
        case loading(reason: String)
        case done
        case fail(with: Error)
        
        var description: String {
            switch self {
            case .waiting:
                return "Waiting"
            case .loading(let work):
                return "Loading \(work)"
            case .done:
                return "Successfully done"
            case .fail(let error):
                return "Failed with error: \(error.localizedDescription)"
            }
        }
    }

}
