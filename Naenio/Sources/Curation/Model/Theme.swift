//
//  Theme.swift
//  Naenio
//
//  Created by 조윤영 on 2022/08/17.
//
import Foundation
import SwiftUI

enum ThemeType: Identifiable {
    case todayVote, hallFame, randomPlay, goldBalance, noisy, collapsedBalance
    
    var id: String {
        switch  self {
        case .todayVote:
            return "TODAY_VOTE"
        case.hallFame:
            return "HALL_OF_FAME"
        case .randomPlay:
            return "RANDOM_PLAY"
        case .goldBalance:
            return "GOLD_BALANCE"
        case .noisy:
            return "NOISY"
        case .collapsedBalance:
            return "COLLAPSED_BALANCE"
        }
    }
    var data: Theme {
        switch  self {
        case .todayVote:
            return Theme(
                content: "오늘 네니오들이\n가장 많이 참여한\n투표",
                title: "오늘의 투표",
                backgroundImageName: "curation_theme01",
                backgroundColorList: [
                    Color(red: 238/255, green: 170/255, blue: 1), Color(red: 201/255, green: 196/255, blue: 249/255), Color(red: 109/255, green: 175/255, blue: 233/255)
            ])
        case .hallFame:
            return Theme(
                content: "네니오들이\n꾸준히 선택한 인기 있는\n투표",
                title: "명예의 전당",
                backgroundImageName: "curation_theme02",
                backgroundColorList: [
                    Color(red: 36/255, green: 206/255, blue: 158/255), Color(red: 170/255, green: 1, blue: 250/255), Color(red: 109/255, green: 175/255, blue: 233/255)
                ])
        case .randomPlay:
            return Theme(
                content: "랜덤으로 참여하는\n플레이 투표",
                title: "랜덤 플레이",
                backgroundImageName: "curation_theme03",
                backgroundColorList: [
                Color(red: 88/255, green: 98/255, blue: 1), Color(red: 165/255, green: 242/255, blue: 1), Color(red: 52/255, green: 161/255, blue: 1)
            ])
        case .goldBalance:
            return Theme(
                content: "어떤 것 하나 쉽게\n선택할 수 없는\n투표",
                title: "황금 밸런스",
                backgroundImageName: "curation_theme04",
                backgroundColorList: [
                    Color(red: 1, green: 169/255, blue: 39/255), Color(red: 1, green: 221/255, blue: 170/255), Color(red: 109/255, green: 175/255, blue: 233/255)
                ])
        case .noisy:
            return Theme(
                content: "네니오들이 가장\n많이 작성한 댓글\n참여 투표",
                title: "와글와글",
                backgroundImageName: "curation_theme05",
                backgroundColorList: [
                    Color(red: 1, green: 156/255, blue: 128/255), Color(red: 1, green: 201/255, blue: 170/255), Color(red: 109/255, green: 175/255, blue: 233/255)
                ])
        case .collapsedBalance:
            return Theme(
                content: "네니오들이\n몰린 투표",
                title: "밸런스 붕괴",
                backgroundImageName: "curation_theme06",
                backgroundColorList: [
                    Color(red: 38/255, green: 189/255, blue: 217/255), Color(red: 175/255, green: 243/255, blue: 1), Color(red: 109/255, green: 151/255, blue: 233/255)
                ])
        }
    }
}

struct Theme {
    var content: String
    var title: String
    var backgroundImageName: String
    var backgroundColorList: [Color]
}
