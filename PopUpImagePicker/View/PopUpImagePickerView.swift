//
//  PopUpImagePickerView.swift
//  PopUpImagePicker
//
//  Created by dsm 5e on 29.05.2023.
//

import SwiftUI
import Photos

struct PopUpImagePickerView: View {
    // MARK: ConnectingViewModel
    @StateObject var imagePickerModel: ImagePickerVM = .init()
    // MARK: Enviroment Values
    @Environment(\.self) var env
    // MARK: CallBacks
    var onEnd: () -> ()
    var onSelect: ([PHAsset]) -> ()
    
    var body: some View {
        
        let deviceSize = UIScreen.main.bounds.size
        VStack(spacing: 0) {
            HStack {
                Text("Selected images")
                    .font(.callout.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    onEnd()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
            }
            .padding([.horizontal,.top])
            .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 12) {
                    ForEach($imagePickerModel.fetchesImages) { $imageAsset in
                        // Grid Content
                        GridContent(imageAsset: imageAsset)
                            .onAppear {
                                if imageAsset.thumbnail == nil {
                                    let manager = PHCachingImageManager.default()
                                    manager.requestImage(for: imageAsset.asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
                                        imageAsset.thumbnail = image
                                    }
                                }
                            }
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    let imageAssets = imagePickerModel.selectedImages.compactMap { imageAsset -> PHAsset? in
                        return imageAsset.asset
                    }
                    onSelect(imageAssets)
                } label: {
                    Text("Add \(imagePickerModel.selectedImages.isEmpty ? "" : "\(imagePickerModel.selectedImages.count) Images")")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(.blue)
                        }
                }
                .disabled(imagePickerModel.selectedImages.isEmpty)
                .opacity(imagePickerModel.selectedImages.isEmpty ? 0.6 : 1)
                .padding(.vertical)
            }
        }
        .frame(height: deviceSize.height / 1.8)
        .frame(maxWidth: (deviceSize.width - 40) > 350 ? 350 : (deviceSize.width - 40))
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(env.colorScheme == .dark ? .black : .white)
        }
        // MARK: Since Its an Overlay View
        // Making It to Take Full Screen Space
        .frame(width: deviceSize.width, height: deviceSize.height, alignment: .center)
    }
    // MARK: Grid Image Content
    @ViewBuilder
    func GridContent(imageAsset: ImageAsset) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                if let thumbnail = imageAsset.thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                } else {
                    ProgressView()
                        .frame(width: size.width, height: size.height, alignment: .center)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.black.opacity(0.1))
                    Circle()
                        .fill(.white.opacity(0.25))
                    Circle()
                        .stroke(.white, lineWidth: 1)
                    
                    if let index = imagePickerModel.selectedImages.firstIndex(where: { asset in
                        asset.id == imageAsset.id
                    }){
                        Circle()
                            .fill(.blue)
                        
                        Text("\(imagePickerModel.selectedImages[index].assetIndex + 1)")
                            .font(.caption2.bold())
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 20, height: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(5)
            }
            .clipped()
            .onTapGesture {
                withAnimation(.easeInOut) {
                    if let index = imagePickerModel.selectedImages.firstIndex(where: { asset in
                        asset.id == imageAsset.id
                    }){
                        imagePickerModel.selectedImages.remove(at: index)
                        imagePickerModel.selectedImages.enumerated().forEach { item in
                            imagePickerModel.selectedImages[item.offset].assetIndex = item.offset
                        }
                    }else{
                        var newAsset = imageAsset
                        newAsset.assetIndex = imagePickerModel.selectedImages.count
                        imagePickerModel.selectedImages.append(newAsset)
                    }
                }
            }
        }
        .frame(height: 70)
    }
}

struct PopUpImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
