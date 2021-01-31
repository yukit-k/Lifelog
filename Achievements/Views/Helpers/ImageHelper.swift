//
//  ImageHelper.swift
//  Achievements
//
//  Created by Yuki Takahashi on 30/01/2021.
//

import SwiftUI

class ImageHelper {
    public func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
            geometry.frame(in: .global).minY
        }
    public func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
            let offset = getScrollOffset(geometry)
            
            // Image was pulled down
            if offset > 0 {
                return -offset
            }
            
            return 0
        }
    public func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }
}
