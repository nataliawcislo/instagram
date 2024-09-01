//
//  PhotoEditView.swift
//  instagram
//
//  Created by Natalia on 01.09.24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


struct PhotoEditView: View {
    @State private var selectedFilter: Filter? = nil
    @State private var image: UIImage
    @State private var editing: Bool = false
    @State private var selectedEditingOption: EditingOption? = nil

    // Variables for editing controls
    @State private var brightness: Double = 0
    @State private var contrast: Double = 1
    @State private var saturation: Double = 1
    @State private var warmth: Double = 0
    @State private var structure: Double = 0
    @State private var color: Double = 0
    @State private var fade: Double = 0
    @State private var blurRadius: Double = 0
    @State private var hue: Double = 0

    let filters: [Filter] = Filter.allCases

    init(image: UIImage) {
        _image = State(initialValue: image)
    }

    var body: some View {
        VStack {
            Image(uiImage: applyFilter(to: image, filter: selectedFilter))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()

            if editing {
                editingControls
            } else {
                filterSelection
            }
            
            Button(action: {
                editing.toggle()
            }) {
                Text(editing ? "Show Filters" : "Edit")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }

    var filterSelection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(filters, id: \.self) { filter in
                    FilterThumbnailView(filter: filter)
                        .onTapGesture {
                            selectedFilter = filter
                        }
                }
            }
            .padding()
        }
    }

    var editingControls: some View {
        VStack {
            HStack {
                editingButton(icon: "sun.max", option: .brightness)
                editingButton(icon: "contrast", option: .contrast)
                editingButton(icon: "saturation", option: .saturation)
                editingButton(icon: "warmth", option: .warmth)
                editingButton(icon: "structure", option: .structure)
                editingButton(icon: "color", option: .color)
                editingButton(icon: "fade", option: .fade)
                editingButton(icon: "blur", option: .blur)
                editingButton(icon: "hue", option: .hue)
            }
            .padding()
            
            if let selectedOption = selectedEditingOption {
                Slider(value: editingValue(for: selectedOption), in: -1...1, step: 0.01) {
                    Text(selectedOption.displayName)
                }
                .padding()
            }
        }
        .padding()
    }

    func editingButton(icon: String, option: EditingOption) -> some View {
        Button(action: {
            selectedEditingOption = (selectedEditingOption == option) ? nil : option
        }) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .padding(8)
                .background(selectedEditingOption == option ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    func editingValue(for option: EditingOption) -> Binding<Double> {
        switch option {
        case .brightness:
            return $brightness
        case .contrast:
            return $contrast
        case .saturation:
            return $saturation
        case .warmth:
            return $warmth
        case .structure:
            return $structure
        case .color:
            return $color
        case .fade:
            return $fade
        case .blur:
            return $blurRadius
        case .hue:
            return $hue
        }
    }

    func applyFilter(to image: UIImage, filter: Filter?) -> UIImage {
        guard let filter = filter else {
            return applyAdjustment(to: image)
        }

        let ciImage = CIImage(image: image)
        let ciContext = CIContext()
        let coreImageFilter = CIFilter(name: filter.rawValue)

        coreImageFilter?.setValue(ciImage, forKey: kCIInputImageKey)

        // Example adjustments for specific filters
        switch filter {
        case .sepia:
            coreImageFilter?.setValue(0.8, forKey: kCIInputIntensityKey)
        case .clarendon:
            coreImageFilter?.setValue(1.5, forKey: kCIInputContrastKey)
        case .lark:
            coreImageFilter?.setValue(0.5, forKey: kCIInputRadiusKey)
        case .loFi:
            coreImageFilter?.setValue(CIVector(x: 1.5, y: 1.5), forKey: kCIInputBrightnessKey)
        default:
            break
        }

        guard let outputCIImage = coreImageFilter?.outputImage else { return image }
        guard let outputCGImage = ciContext.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }

        return UIImage(cgImage: outputCGImage)
    }
    
    func applyAdjustment(to image: UIImage) -> UIImage {
        let ciImage = CIImage(image: image)
        let ciContext = CIContext()
        let colorControlsFilter = CIFilter.colorControls()
        
        colorControlsFilter.inputImage = ciImage
        colorControlsFilter.brightness = Float(brightness)
        colorControlsFilter.contrast = Float(contrast)
        colorControlsFilter.saturation = Float(saturation)
        
        let exposureAdjustFilter = CIFilter.exposureAdjust()
        exposureAdjustFilter.inputImage = colorControlsFilter.outputImage
        exposureAdjustFilter.ev = Float(warmth)
        
        let vignetteFilter = CIFilter.vignette()
        vignetteFilter.inputImage = exposureAdjustFilter.outputImage
        vignetteFilter.intensity = Float(structure)
        
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = vignetteFilter.outputImage
        blurFilter.radius = Float(blurRadius)
        
        let hueAdjustFilter = CIFilter.hueAdjust()
        hueAdjustFilter.inputImage = blurFilter.outputImage
        hueAdjustFilter.angle = Float(hue * .pi) // Convert to radians
        
        let outputCIImage = hueAdjustFilter.outputImage?.cropped(to: ciImage?.extent ?? CGRect.zero)
        guard let outputCGImage = ciContext.createCGImage(outputCIImage ?? ciImage!, from: ciImage!.extent) else { return image }

        return UIImage(cgImage: outputCGImage)
    }
}



struct PhotoEditView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEditView(image: UIImage(named: "examplePhoto")!) // Upewnij się, że obraz o tej nazwie istnieje
    }
}
