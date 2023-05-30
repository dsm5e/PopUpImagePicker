//
//  ContentView.swift
//  PopUpImagePicker
//
//  Created by dsm 5e on 29.05.2023.
//

import SwiftUI
import Photos

struct ContentView: View {
    @State var showPicker: Bool = false
    @State var pickedImages: [UIImage] = []
    
    var body: some View {
        
        NavigationStack {
            TabView {
                ForEach(pickedImages, id: \.self) { image in
                    GeometryReader { proxy in
                        let size = proxy.size
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .cornerRadius(15)
                    }
                    .padding()
                }
            }
            .frame(height: 450)
            .tabViewStyle(.page(indexDisplayMode: pickedImages.isEmpty ? .never : .always))
            .navigationTitle("Popup Image Picker")
            .toolbar {
                Button {
                    showPicker.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .popUpImagePicker(show: $showPicker) { assets in
            let manager = PHCachingImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            DispatchQueue.global(qos: .userInteractive).async {
                assets.forEach { asset in
                    manager.requestImage(for: asset, targetSize: .init(), contentMode: .default, options: options) { image, _ in
                        guard let image = image else { return }
                        DispatchQueue.main.async {
                            self.pickedImages.append(image)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
