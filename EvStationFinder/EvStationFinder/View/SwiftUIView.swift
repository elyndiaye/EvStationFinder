//
//  SwiftUIView.swift
//  EvStationFinder
//
//  Created by Ely Assumpcao Ndiaye on 13/09/25.
//

import SwiftUI


public enum CarouselStyle: String, Codable, CaseIterable {
    case large, medium, small
    
    var widhtPercentage: CGFloat {
        switch self {
        case .large: 1
        case .medium: 0.9
        case .small:0.6
        }
    }
    
    var spacing: CGFloat {
        switch self {
        case .large: .zero
        case .medium, .small: CGFloat(8)
        }
    }
    
    var contentBottomPading: CGFloat {
        CGFloat(8)
    }
}

fileprivate struct ItemSizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = CGSize(width: max(value.width, nextValue().width),
                       height: max(value.width, nextValue().height))
    }
}

struct Carousel<Content: View, T: Identifiable>: View {
    //Binding permite que a classe altere a variavel fora da view
    @Binding private var buttonEnable: Bool
    @Binding private var currentIndex: Int
    @GestureState private var offset: CGFloat = .zero
    
    private let carouselSpacingBetwenItems: Bool
    @State private var contentHeight: CGFloat = 0
    
    private let style: CarouselStyle
    private let items: [T]
    private var content: (T) -> Content
    private var onSwipe: (_ cuttentIndex: Int) -> Void
    private let horizontalPaddings: (CGFloat, CGFloat)
    
    public init(
        style: CarouselStyle = .medium,
        index: Binding<Int>,// O que é o index?
        buttonEnable: Binding<Bool>,
        carouselSpacingBetwenItems: Bool = true,
        horizontalPaddings: (CGFloat, CGFloat) = (.zero, .zero),
        items: [T],
        @ViewBuilder content: @escaping (T) -> Content,
        onSwipe: @escaping (Int) -> Void = { _ in }) {
            self.style = (items.count == 1 && style == .small) ? CarouselStyle.medium : style
            self._currentIndex = index //pq tem um _ na frente ? Pq to acessado diretamente a proriepreade wapper se tem @Binding precisa do _
            self._buttonEnable = buttonEnable
            self.horizontalPaddings = horizontalPaddings
            self.items = items
            self.content = content
            self.onSwipe = onSwipe
            self.carouselSpacingBetwenItems = carouselSpacingBetwenItems
        }
    
    var isFirstTab: Bool {
        currentIndex == .zero
    }
    
    var isLastTab: Bool {
        currentIndex == (items.count - 1)
    }
    
    var isSingle: Bool  {
        items.count == 1
    }
    
    var body: some View {
        if items.isEmpty {
            EmptyView()
        }else {
            if UIAccessibility.isVoiceOverRunning {
                ForEach(items) {item in
                    content(item)
                }
            } else {
                VStack(spacing: carouselSpacingBetwenItems ? style.contentBottomPading : .zero) {
                    GeometryReader { proxy in
                        let proxyWidth = proxy.size.width
                        let traillingSpace = proxyWidth * (1 - style.widhtPercentage)
                        let width = proxyWidth - traillingSpace + style.spacing
                        let adjustedWidth = (traillingSpace / 2) - style.spacing
                        
                        HStack(spacing: carouselSpacingBetwenItems ? style.spacing : .zero) {
                            ForEach(items) { item in
                                content(item)
                                    .padding(EdgeInsets(top: 0,
                                                        leading: horizontalPaddings.0,
                                                        bottom: 0,
                                                        trailing: horizontalPaddings.1))
                                    .frame(width: proxyWidth - traillingSpace + (isSingle ? style.spacing : .zero))
                                    .background(GeometryReader { innerProxy in
                                        Color.clear.preference(key: ItemSizePreferenceKey.self, value: innerProxy.size)
                                    })
                            }
                        }.onPreferenceChange(ItemSizePreferenceKey.self) { newSize in
                            contentHeight = newSize.height
                        }
                        .padding(.horizontal, style.spacing)
                        .offset(x: (CGFloat(currentIndex) * -width) + (!isFirstTab ? adjustedWidth : style.spacing) + offset)
                        .highPriorityGesture(
                            DragGesture().updating($offset, body: { value, out, _ in
                                out = value.translation.width
                            })
                            .onEnded({ value in
                                let offsetX = value.translation.width * 1.65
                                let velocityX = value.velocity.width
                                let progress = -offsetX / width
                                
                                let shortSwipeThreshold: CGFloat = 20
                                let longSwipeThreshold: CGFloat = 0.35
                                
                                if abs(offsetX) > shortSwipeThreshold && abs(velocityX) < 400 {
                                    if offsetX > 0 {
                                        currentIndex = max(currentIndex - 1, 0)
                                    }
                                    else {
                                        currentIndex = min(currentIndex + 1, items.count - 1)
                                    }
                                } else if progress >= longSwipeThreshold {
                                    currentIndex = min(currentIndex - 1, 0)
                                } else if progress < -longSwipeThreshold {
                                    currentIndex = max(currentIndex - 1, 0)
                                }
                                onSwipe(currentIndex)
                            })
                        )
                    }
                    .frame(idealHeight: contentHeight)
                    .animation(.easeInOut, value: currentIndex)
                    if !isSingle {
                        //Todo
                        //                        Indicator(
                        //                            currentIndex: $currentIndex,
                        //                            buttonEnable: $buttonEnable,
                        //                            numberOfItems: items.count) { _ in
                        //                                onSwipe(currentIndex)
                        //                            }
                        IndicatorView(
                               numberOfPages: items.count,
                               currentIndex: currentIndex
                           )
                           .padding(.top, 8)
                    }
                    
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// 1. Defina um modelo que seja Identifiable e tenha 'title'
struct SampleItem: Identifiable {
    let id = UUID()
    let title: String
}

// 2. Crie uma View que use seu Carousel com esse tipo
struct CarouselPreview: View {
    @State private var currentIndex = 0
    @State private var buttonEnabled = true

    private let items: [SampleItem] = [
        SampleItem(title: "Item 1"),
        SampleItem(title: "Item 2"),
        SampleItem(title: "Item 3")
    ]

    var body: some View {
        Carousel(
            style: .medium,
            index: $currentIndex,
            buttonEnable: $buttonEnabled,
            items: items
        ) { item in
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
                Text(item.title)
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(height: 150)
        }
        .padding()
    }
}

// 3. Use a sintaxe correta do Preview
#Preview {
    CarouselPreview()
}
