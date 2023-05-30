//
//  Extensions.swift
//  PopUpImagePicker
//
//  Created by dsm 5e on 30.05.2023.
//

import SwiftUI
import Photos

// MARK: Custom modifier

extension View {
    @ViewBuilder
    func popUpImagePicker(show: Binding<Bool>,transition: AnyTransition = .move(edge: .bottom), onSelect: @escaping ([PHAsset]) -> ()) -> some View {
        self
            .overlay {
                let deviceSize = UIScreen.main.bounds.size
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .opacity(show.wrappedValue ? 1 : 0)
                        .onTapGesture {
                            show.wrappedValue = false
                        }
                    if show.wrappedValue {
                        PopUpImagePickerView {
                            show.wrappedValue = false
                        } onSelect: { assets in
                            onSelect(assets)
                            show.wrappedValue = false
                        }
                        .transition(transition)
                    }
                }
                .frame(width: deviceSize.width, height: deviceSize.height)
                .animation(.easeInOut, value: show.wrappedValue)
            }
    }
}
