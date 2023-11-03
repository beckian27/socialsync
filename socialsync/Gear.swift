//
//  Gear.swift
//  socialsync
//
//  Created by Yuansong Wang on 11/1/23.
//

import SwiftUI
import UIKit
func change_back(list: [RectangleView], num: Int) -> [RectangleView]{
    var temp = list
    temp[num].color = Color.red
    return temp
}
func change_color(list: [RectangleView], num: Int) -> [RectangleView]{
    var temp = list
    temp[num].color = Color.green
    return temp
}
func createRectangles(num: Int) -> [RectangleView]{
    var rects: [RectangleView] = []
    for _ in 0...num{
        let temp1 = 400.0 / Double(num) - 2.0
        var temp2 = Double(rects.count) * 400.0 / Double(num)
        temp2 -= 200 - temp1/2
        rects.append(RectangleView(id: rects.count + 1, color: Color.red, width: temp1, offset: temp2))
    }
    return rects;
}

struct Gear: View {
    var gears = Image("gear")
    @State var rectangles : [RectangleView] = createRectangles(num: 5)
    @State var green_bar = 0.0
    @State var last_false: Double = 0.0
    @Environment(\.presentationMode) var presentationMode
    @State var current: CGFloat? = nil
    @State var rectangleColor = Color.blue
    @State var rotation = 0.0
    @State var barv = 0.0
    @State var loops = 0.0
    @State private var isATriggered = false
    @State private var isBTriggered = false
    var rect1 = CGRect(x: 20, y: 20, width: 100, height: 100)
    
    var body: some View {
                gears
            
                    .resizable()
                    .frame(width: 250, height: 250)
                    .rotationEffect(Angle(radians: rotation))
                    
                    .gesture(
                        DragGesture()
                            
                            .onChanged { value in
                                if !isATriggered{
                                    last_false = barv
                                    //createRectangles()
                                    //print("yes")
                                }
                                isATriggered = true
                                let newYValue = value.location.y - 125
                                let newXValue = value.location.x - 125
                                var temp = atan(abs(newYValue / newXValue))
                                if newYValue < 0{
                                    //below y
                                    if newXValue > 0{
                                        //fourth quad
                                        temp = 2 * Double.pi - temp
                                    }else{
                                        //third quad
                                        temp = Double.pi + temp
                                    }
                                }else{
                                    //above y
                                    if newXValue > 0{
                                        //first quad
                                        //temp = temp
                                    }else{
                                        //second quad
                                        temp = Double.pi - temp
                                    }
                                }
                                if rotation > 340 * 2 * Double.pi / 360 && temp > 0 && temp < 40 * Double.pi / 360{
                                    rectangles = change_color(list: rectangles, num: Int(loops))
                                    loops += 1
                                }
                                if temp > 340 * 2 * Double.pi / 360 && rotation > 0 && rotation < 40 * Double.pi / 360{
                                    rectangles = change_back(list: rectangles, num: Int(loops))
                                    loops -= 1
                                }
                                rotation = temp
                                barv = rotation + loops * Double.pi * 2
                                green_bar = barv
                            }
                            .onEnded{ value in
                                isATriggered = false
                            }
                    )
                
               
//                    .gesture(DragGesture(minimumDistance: 0)
//                                    .onChanged { _ in
//                                        isBTriggered = true
//                                    }
//                                    .onEnded { _ in
//                                        isBTriggered = false
//                                    }
//                                )
                Rectangle()
                        .frame(width: 399, height: 20)
                        .foregroundColor(rectangleColor)
                        .cornerRadius(10)
                        .offset(y:-1.5)
                        .zIndex(0)
//                Rectangle()
//                    .frame(width: 24 * green_bar, height: 20)
//                    .foregroundColor(Color.green)
//                    .cornerRadius(10)
//                    .offset(x:-190, y:-61)
                    
                    
                ZStack {
                    
                    ForEach(rectangles, id: \.id) { rectangle in
                        Rectangle()
                            .frame(width: rectangle.width, height: 20)
                            //.cornerRadius(10)
                            .foregroundColor(rectangle.color)
                            .offset(x: rectangle.offset, y: -44) // Offset the Rectangle up
                            .zIndex(1)
                            }
                    Slider(value: $barv, in: 0...10*Double.pi)
                        .zIndex(100)
                        .offset(y: -44)
                        .onChange(of: barv) { oldValue, newValue in
                            if newValue - loops * 2 * Double.pi > 2 * Double.pi{
                                loops += 1
                            }
                            if newValue - loops * 2 * Double.pi < -2 * Double.pi{
                                loops -= 1
                            }
                            rotation = newValue - loops * Double.pi * 2
                           }
                    Button(action: {
                        print("Submitted")
                        //pass to api to delete the invite
                        presentationMode.wrappedValue.dismiss()
                        // exit current scope and delete the invitation.
                    }) {
                        Text("Submit")
                            .font(.system(size: 14))
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(red: 88 / 255, green: 224 / 255, blue: 133 / 255))
                            .cornerRadius(5)
                            .padding(.horizontal, 20)
                    }
                    .offset(y:30)
                }
    
        
    }
    
}
struct RectangleView {
    var id: Int
    var color: Color
    var width: Double
    var offset: Double
}
#Preview {
    Gear()
}
