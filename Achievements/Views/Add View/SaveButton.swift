//
//  SaveButton.swift
//  Achievements
//
//  Created by Yuki Takahashi on 26/01/2021.
//

import SwiftUI

struct SaveButton: View {
    var function: () -> Void
    
    var body: some View {
        Button(action: {
            self.function()
        }) {
            Text("Save")
                .fontWeight(.bold)
                .font(.headline)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(6)
                .padding(.leading)
        }
    }
}


struct SaveButton_Previews: PreviewProvider {
    static var previews: some View {
        SaveButton(function: {print("test")})
    }
}
