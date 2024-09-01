//
//  Filter.swift
//  instagram
//
//  Created by Natalia on 01.09.24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

enum Filter: String, CaseIterable {
    case sepia = "CISepiaTone"
    case blackWhite = "CIPhotoEffectMono"
    case vintage = "CIPhotoEffectTransfer"
    case clarendon = "CIColorControls"
    case gingham = "CIPhotoEffectChrome"
    case lark = "CIVignette"
    case moon = "CIPhotoEffectNoir"
    case loFi = "CISRGBToneCurveToLinear"
    
    var displayName: String {
        switch self {
        case .clarendon: return "Clarendon"
        case .gingham: return "Gingham"
        case .lark: return "Lark"
        case .moon: return "Moon"
        case .vintage: return "Vintage"
        case .loFi: return "Lo-Fi"
        default: return self.rawValue
        }
    }
}

enum EditingOption: String, CaseIterable {
    case brightness, contrast, saturation, warmth, structure, color, fade, blur, hue
    
    var displayName: String {
        switch self {
        case .brightness: return "Brightness"
        case .contrast: return "Contrast"
        case .saturation: return "Saturation"
        case .warmth: return "Warmth"
        case .structure: return "Structure"
        case .color: return "Color"
        case .fade: return "Fade"
        case .blur: return "Blur"
        case .hue: return "Hue"
        }
    }
}
