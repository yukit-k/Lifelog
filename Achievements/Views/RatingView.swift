//
//  RatingView.swift
//  Achievements
//
//  Created by Yuki Takahashi on 16/01/2021.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var label = LocalizedStringKey("Rating")
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            
            ForEach(1 ..< maximumRating + 1) { number in
                self.image(for: number)
                    .foregroundColor(number > self.rating ? self.offColor: self.onColor)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
