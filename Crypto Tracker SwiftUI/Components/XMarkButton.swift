//
//  XMarkButton.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 25/12/22.
//

import SwiftUI

struct XMarkButton: View {
    
//    @Environment(\.dismiss) var dismiss
    @Binding var dismiss:Bool
    
    var body: some View {
        Button(action: {
            dismiss.toggle()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton(dismiss: .constant(true))
    }
}
