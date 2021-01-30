//
//  SaveContinueButton.swift
//  Achievements
//
//  Created by Yuki Takahashi on 26/01/2021.
//

import SwiftUI

struct SaveContinueButton: View {
    var function: () -> Void
    
    var body: some View {
        Button(action: {
            self.function()
        }) {
            Text("Save & Continue")
                .fontWeight(.medium)
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.leading)
        }
    }
}

struct SaveContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        SaveContinueButton(function: {print("test")})
    }
}
