//
//  CameraCaptureView.swift
//  PlantGuard
//
//  Created on 2024
//

import SwiftUI
import PhotosUI
import AVFoundation

struct CameraCaptureView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showCamera = false
    
    let onImageSelected: (UIImage) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 500)
                            .cornerRadius(20)
                            .padding()
                        
                        Button(action: {
                            // Call callback - parent will handle sheet dismissal
                            onImageSelected(image)
                        }) {
                            Text("Use This Photo")
                                .appButton()
                        }
                        .padding(.horizontal)
                    } else {
                        VStack(spacing: 40) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Select Photo to Identify")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 24) {
                                Button(action: {
                                    showCamera = true
                                }) {
                                    VStack(spacing: 12) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 44))
                                        Text("Camera")
                                            .font(.headline)
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: 140, height: 140)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                                
                                PhotosPicker(selection: $selectedItem, matching: .images) {
                                    VStack(spacing: 12) {
                                        Image(systemName: "photo.fill")
                                            .font(.system(size: 44))
                                        Text("Photo Library")
                                            .font(.headline)
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: 140, height: 140)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraPickerView(image: $selectedImage)
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
        }
    }
}

// TODO: Replace with full AVFoundation implementation
struct CameraPickerView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPickerView
        
        init(_ parent: CameraPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Update image on main thread
            DispatchQueue.main.async {
                if let image = info[.originalImage] as? UIImage {
                    self.parent.image = image
                }
            }
            // Dismiss camera picker only (not parent sheet)
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

