//
//  ImagePickerVM.swift
//  PopUpImagePicker
//
//  Created by dsm 5e on 29.05.2023.
//

import SwiftUI
import PhotosUI

class ImagePickerVM: ObservableObject {
    //MARK: Properties
    @Published var fetchesImages: [ImageAsset] = []
    @Published var selectedImages: [ImageAsset] = []
    
    init() {
        fetchImages()
    }
    
    func fetchImages() {
        //MARK: Fetching images
        let options = PHFetchOptions()
        //MARK: Modify as per your wish
        options.includeHiddenAssets = false
        options.includeAssetSourceTypes = [.typeUserLibrary]
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        PHAsset.fetchAssets(with: .image, options: options).enumerateObjects { asset, _, _ in
            let imageAsset: ImageAsset = .init(asset: asset)
            self.fetchesImages.append(imageAsset)
        }
    }
}

