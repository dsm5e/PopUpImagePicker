//
//  ImageAsset.swift
//  PopUpImagePicker
//
//  Created by dsm 5e on 29.05.2023.
//

import SwiftUI
import PhotosUI

//MARK: Selected image asset model
struct ImageAsset: Identifiable {
    var id: String = UUID().uuidString
    var asset: PHAsset
    var thumbnail: UIImage?
    // Selected Image index
    var assetIndex: Int = -1
}

