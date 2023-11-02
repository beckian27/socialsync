//
//  Gear.swift
//  socialsync
//
//  Created by Yuansong Wang on 11/1/23.
//

import SwiftUI
import UIKit


struct Gear: View {
    var gears = Image("gear")
    @State var current: CGFloat? = nil
    //var current = UIOneFingerRotationGes()
    @State var rotation = 0.0
    
    var body: some View {
                gears
                    .resizable()
                    .frame(width: 250, height: 250)
//                    .position(x:196.5, y:380)
                    .rotationEffect(Angle(radians: rotation), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newYValue = value.location.y
                                let newXValue = value.location.x
                                rotation = tanh((newYValue-380)/(newXValue-196.5))
                                }
                    )
            }
}

#Preview {
    Gear()
}
