# Naenio-iOS
<img width="2322" alt="iShot_2022-08-25_20 40 40" src="https://user-images.githubusercontent.com/46271447/186655078-2c9f9354-5a3a-4334-90ff-b5d57756ff7e.png">

<p align="center">

 [<img src="https://user-images.githubusercontent.com/46271447/193392398-7cb8d230-2e0f-4a2f-8802-fe4f1fdf8b42.png" height="80">](https://apps.apple.com/kr/app/%EB%84%A4%EB%8B%88%EC%98%A4/id1634376427)
[<img src="https://user-images.githubusercontent.com/46271447/193523600-3b736069-93be-4bdb-8db6-16f47c4004b0.png" height="80">](https://play.google.com/store/apps/details?id=com.nexters.teamversus.naenio)

</p>

네니오 iOS앱을 위한 저장소입니다

## 🎨 Environment
- Xcode 13.0 ~
- iOS 14.0 ~

## 🔨 Made with 
### UI framework
- SwiftUI (mainly)
- UIKit (partially)
- Introspect

### Async programming
- RxSwift (for networking)
- Combine (for system)

### Networking
- Moya
- Alamofire

### Dependency management
- CocoaPods(mainly)
- SPM(partially)

### Deploy management
- Fastlane
- Fastlane match (for cert & profile)

### ETC
- KakaoAuthSDK
- SwiftLint
- Lottie

## 💾 How to build?
#### 1. 종속성 설치
터미널 내에서 프로젝트 폴더로 이동해 다음 명령어를 실행해 종속성을 설치해주세요.
``` Bash
pod install
```

#### 2. ignored 파일 불러오기
- ignored된 파일은 `naenio-ios-ignored`라는 이름으로 @enebin(repo author)의 개인 레포로 관리되고 있습니다. 해당 레포에 대한 권한은 직접 문의 바랍니다.
- 터미널 내에서 프로젝트 폴더로 이동해 다음 명령어를 실행해 파일을 다운받은 뒤 프로젝트 내 `ignored`폴더에 넣어주세요.
``` Bash
git clone naenio-ios-ignored
```

#### 3. match 인증서 불러오기
- 프로젝트에서 배포용으로 관리되는 인증서는 `naenio-fastlane-match`라는 이름으로 @enebin(repo author)의 개인 레포로 관리되고 있습니다. 해당 레포에 대한 권한은 직접 문의 바랍니다.
- 안 필요할 수도 있으므로 일단 생략합니다,, 나중에 쓰겟음

## 👩‍👩‍👧‍👦 Family repos
- [네니오 안드로이드](https://github.com/Nexters/naenio-android)
- [네니오 서버](https://github.com/Nexters/naenio-server)
- [네니오 웹페이지](https://github.com/Nexters/naenio-web)



