//
//  unscrollableBottomSheet.swift
//  Naenio
//
//  Created by YoungBin Lee on 2022/08/16.
//

import SwiftUI

struct HalfSheet<C: View>: View {
    @State private var draggedOffset: CGFloat = 0
    @State private var previousDragValue: DragGesture.Value?

    @Binding var isPresented: Bool
    
    private let ratio: CGFloat
    private let isLow: Bool
    
    private let topBarHeight: CGFloat
    private let topBarCornerRadius: CGFloat
    private let topBarTitle: String
    private let content: C

    private let bgColor: Color
    
    
    private var grayBackgroundOpacity: Double {
        if !isPresented {
            return 0
        } else if isLow {
            return 0.4
        } else {
            return 0.01
        }
    }
    
    init(
        isPresented: Binding<Bool>,
        ratio: CGFloat,
        topBarHeight: CGFloat = 64,
        topBarCornerRadius: CGFloat = 22,
        topBarTitle: String,
        bgColor: Color = Color.card,
        @ViewBuilder content: () -> C
    ) {
        self.isLow = false
        self._isPresented = isPresented
        self.bgColor = bgColor
        self.ratio = ratio
        self.topBarHeight = topBarHeight
        self.topBarCornerRadius = topBarCornerRadius
        self.topBarTitle = topBarTitle
        
        self.content = content()
    }
    
    init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> C
    ) {
        self.isLow = true
        self._isPresented = isPresented
        self.bgColor = Color.card
        self.ratio = 0.28
        self.topBarHeight = 20
        self.topBarTitle = ""
        self.topBarCornerRadius = 22
        
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size != .zero {
                ZStack {
                    fullScreenLightGrayOverlay()
                    
                    VStack(spacing: 0) {
                        if isLow {
                            self.topIndicator
                                .padding(.top, 20)

                        } else {
                            self.topBar
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                        }
                        
                        CustomDivider()
                            .opacity(isLow ? 0 : 1)
                            .padding(.top, 10)
                            .padding(.bottom, 30)
                        
                        VStack(spacing: -8) {
                            self.content.padding(.bottom, geometry.safeAreaInsets.bottom)
                            Spacer()
                        }
                    }
                    .frame(height: sheetHeight(in: geometry) - min(self.draggedOffset, 0))
                    .background(self.bgColor)
                    .cornerRadius(self.topBarCornerRadius, corners: [.topLeft, .topRight])
                    .animation(.interactiveSpring())
                    .offset(y: self.isPresented ? (geometry.size.height/2 - sheetHeight(in: geometry)/2 + geometry.safeAreaInsets.bottom + self.draggedOffset) : (geometry.size.height/2 + sheetHeight(in: geometry)/2 + geometry.safeAreaInsets.bottom))
                }
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            // ignore gestures while the sheet is hidden. Otherwise it could collide with the iOS-global "go to home screen"-gesture
                            guard isPresented else { return }

                            let offsetY = value.translation.height
                            if offsetY > 0 {
                                self.draggedOffset = offsetY
                            } else {
                                self.draggedOffset = 0
                            }
                            
                            if let previousValue = self.previousDragValue {
                                let previousOffsetY = previousValue.translation.height
                                let timeDiff = Double(value.time.timeIntervalSince(previousValue.time))
                                let heightDiff = Double(offsetY - previousOffsetY)
                                let velocityY = heightDiff / timeDiff
                                if velocityY > 1400 {
                                    self.isPresented = false
                                    return
                                }
                            }
                            self.previousDragValue = value
                            
                        })
                        .onEnded({ (value) in
                            let offsetY = value.translation.height
                            if offsetY > self.sheetHeight(in: geometry) {
                                self.isPresented = false
                            }
                            self.draggedOffset = 0
                        })
                )
            } else {
                EmptyView()
            }
        }
    }
    
    fileprivate func sheetHeight(in geometry: GeometryProxy) -> CGFloat {
        return geometry.size.height * ratio
    }
    
    fileprivate func fullScreenLightGrayOverlay() -> some View {
        Color.black
            .opacity(grayBackgroundOpacity)
            .edgesIgnoringSafeArea(.all)
            .animation(.interactiveSpring())
            .onTapGesture { self.isPresented = false }
    }
    
    var topBar: some View {
        
        HStack(alignment: .center) {
            Text(topBarTitle)
                .font(.semoBold(size: 18))
                .foregroundColor(.white)
            
            Spacer()
            
            CloseButton(action: { isPresented = false })
                .frame(width: 14, height: 14)
        }
        .background(bgColor)
    }
    
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.subCard)
            .frame(width: 46, height: 5)
    }
}
