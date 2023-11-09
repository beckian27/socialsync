//
//  Gear.swift
//  socialsync
//
//  Created by Yuansong Wang on 11/1/23.
//

import SwiftUI
import UIKit
func change_back(list: [RectangleView], num: Int) -> [RectangleView]{
    if num < 0 || num > list.count - 1{
        return list
    }
    var temp = list
    temp[num].color = Color.red
    return temp
}
func change_color(list: [RectangleView], num: Int) -> [RectangleView]{
    if num < 0 || num > list.count - 1{
        return list
    }
    var temp = list
    temp[num].color = Color.green
    return temp
}
func createRectangles(num: Int) -> [RectangleView]{
    var rects: [RectangleView] = []
    for _ in 0...num{
        let temp1 = 400.0 / Double(num) - 2.0
        var temp2 = Double(rects.count) * 420.0 / Double(num)
        temp2 -= 200 - temp1/2
        rects.append(RectangleView(id: rects.count + 1, color: Color.red, width: temp1, offset: temp2))
    }
    return rects;
}
func reset_color(rect: [RectangleView], num: Int) -> [RectangleView]{
    var temp = rect
    if temp[num].color == Color.green{
        temp[num].color = Color.red
    }else{
        temp[num].color = Color.green
    }
    return temp
}
struct Gear: View {
    var gears = Image("gear")
    var pointer = Image("pointer")
    @State var pp: Double = -190.0
    @State var rectangles : [RectangleView] = createRectangles(num: 5)
    @State var green_bar = 0.0
    @State var last_false: Double = 0.0
    @Environment(\.presentationMode) var presentationMode
    @State var current: CGFloat? = nil
    @State var current_block = 0
    @State var rectangleColor = Color.blue
    @State var rotation = 0.0
    @State var barv = 0.0
    @State var gap = 0.0
    @State var loops = 0.0
    @State private var isATriggered = false
    @State private var isBTriggered = false
    @State var date = "10/27/2023"
    var rect1 = CGRect(x: 20, y: 20, width: 100, height: 100)
    @State var once:Bool = false

    
    var body: some View {
        Text("Available")
            
            .foregroundColor(Color.green)
                gears
                    .resizable()
                    .frame(width: 250, height: 250)
                    .rotationEffect(Angle(radians: rotation))
        
                    .offset(y:-10)
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
                                
//                                if rotation > 340 * 2 * Double.pi / 360 && temp > 0 && temp < 40 * Double.pi / 360{
//                                    rectangles = change_color(list: rectangles, num: Int(loops))
//                                    loops += 1
//                                }
//                                if temp > 340 * 2 * Double.pi / 360 && rotation > 0 && rotation < 40 * Double.pi / 360{
//                                    //rectangles = change_back(list: rectangles, num: Int(loops))
//                                    loops += 1
//                                }
                                temp = abs(temp)
                                var avil = true
                                if rotation > temp{
                                    avil = false
                                }
                                var diff = abs(rotation - temp)
                                if diff > Double.pi{
                                    avil = !avil
                                    diff = abs(diff - 2*Double.pi)
                                }
                                barv += diff
                                rotation = abs(temp)
                                green_bar = barv
                                pp = -190 + barv/(2*Double.pi)*70
                                gap = 460.0 - rectangles[0].width * Double(rectangles.count)
                                print(gap)
                                gap /= -(Double(rectangles.count) - 1.0)
                                gap *= Double(current_block)
                                if (pp + 190.0) > Double((Double(current_block) + 1.0) * rectangles[0].width + gap ) {
                                    if avil{
                                        rectangles = change_color(list: rectangles, num: current_block)
                                    }
                                    current_block += 1
                                }
//                                print(pp)
                                if pp > 200 {
                                    pp = 200
                                }
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
//                Rectangle()
//                        .frame(width: 450, height: 20)
//                        .foregroundColor(rectangleColor)
//                        .cornerRadius(10)
//                        .offset(y:-3)
//                        .zIndex(0)
//                Rectangle()
//                    .frame(width: 24 * green_bar, height: 20)
//                    .foregroundColor(Color.green)
//                    .cornerRadius(10)
//                    .offset(x:-190, y:-61)
                Text("9:00      9:30       10:00        10:30         11:00     11:30")
                    .offset(x:0,y:30)
                ZStack {
                    Text(date)
                        .offset(x:0,y:10)
                    ForEach(0 ..< rectangles.count) {id in
                        @State var temp = rectangles[id].color
                        Rectangle()
                            .frame(width: rectangles[id].width, height: 20)
                            //.cornerRadius(10)
                            .offset(x: rectangles[id].offset, y: -40) // Offset the Rectangle up
                            .zIndex(1)
                            .onTapGesture{
                                print("yes")
                                rectangles = reset_color(rect: rectangles, num: id)
                                temp = Color.green
                            }
                            .foregroundColor(temp)
                    }
                    
                    pointer
                        .resizable()
                                    .scaledToFit() // Maintain the aspect ratio of the image
                                    .scaleEffect(0.07) // Adjust the scaling factor as needed
                                    
                                    .offset(x: pp, y:  -65)
//                        .resizable()
//                        .frame(width: 50, height: 50)
//                    Text("Unavailable")
//                        .foregroundColor(Color.red)
//                        .offset( x:-150, y: -105)
                    Slider(value: $barv, in: 0...10*Double.pi)
                        .zIndex(100)
                        .offset(y: -78 )
//                        .onChange(of: barv) { newValue in
//                            if newValue - loops * 2 * Double.pi > 2 * Double.pi{
//                                loops += 1
//                            }
//                            if newValue - loops * 2 * Double.pi < -2 * Double.pi{
//                                loops -= 1
//                            }
//                            rotation = newValue - loops * Double.pi * 2
//                           }
                    Button(action: {
                        print("Submitted")

                        //pass to api to delete the invite
                        if !once {
                            once = true
                            date = "10/28/2023"
                        }else{
                            let _:[String] = apipost(endpoint: "/test/1/", parameters: [:])
                            presentationMode.wrappedValue.dismiss()

                        }
                        
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
                    .offset(y:50)
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
