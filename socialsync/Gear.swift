//
//  Gear.swift
//  socialsync
//
//  Created by Yuansong Wang on 11/1/23.
//

import SwiftUI
import UIKit
struct Arrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.height * 0.3))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.7))
        path.addLine(to: CGPoint(x: rect.width * 0.6, y: rect.height * 0.6))
        path.addLine(to: CGPoint(x: rect.width * 0.6, y: rect.height * 0.8))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width * 0.6, y: rect.height * 0.2 ))
        path.addLine(to: CGPoint(x: rect.width * 0.6, y: rect.height * 0.4 ))
        
        return path
    }
}

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
    for i in 0..<num{
        let temp1 = (360.0 - 2.0 * Double(num)) / Double(num)
        var temp2 = Double(i) * (temp1 + 2) + 10
        temp2 -= 190 - temp1/2
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

//example date intervals for testing
let currentDate = Date()
let interval1 = DateInterval(start: currentDate, duration: 10800) // 3 hour
let interval2 = DateInterval(start: currentDate.addingTimeInterval(3600*24), end: currentDate.addingTimeInterval(3600*32)) // 1 hour from now to 2 hours from now
//let interval3 = DateInterval(start: currentDate.addingTimeInterval(7200), duration: 3600) // 1 hour from 2 hours from now

var possible_time: [DateInterval] = [interval1, interval2] //call api here to get the possible time and make it a state var in Gear: view
var current_index_on_possible_time = 0 //which time interval we are on
var list_time: [DateInterval] = [] //our return list of availabilities
func get_proper_length(x: DateInterval) -> (Double, Int){
    let durationInSeconds = x.duration
    let durationInHours = durationInSeconds / 3600
    if durationInHours >= 10{
        return (durationInHours / 2, 7200) //two hours
    }else if durationInHours < 5 {
        return (durationInHours * 2, 1800) //half an hour
    }
    return (durationInHours, 3600) //exactly one hour
}
func date_to_date(x: Date) -> String{
    let df = DateFormatter()
    df.dateFormat = "MM/dd/yyyy"
    return df.string(from: x)
}
func date_to_string(x: Date) -> String{
    let df = DateFormatter()
    df.dateFormat = "HH:mm"
    return df.string(from: x)
}
struct Gear: View {
    let invite_id: Int
    var gears = Image("gear")
    var pointer = Image("pointer")
    @State var pp: Double = -180.0
    @State var num_rect = Int(get_proper_length(x: possible_time[current_index_on_possible_time]).0)
    @State var time_seg = get_proper_length(x: possible_time[current_index_on_possible_time]).1
    @State var rectangles : [RectangleView] = createRectangles(num: Int(get_proper_length(x: possible_time[current_index_on_possible_time]).0))
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
    @State var speed_transform = 100.0
    @State private var isATriggered = false
    @State private var isBTriggered = false
    @State var date = date_to_date(x: possible_time[current_index_on_possible_time].start)
    var rect1 = CGRect(x: 20, y: 20, width: 100, height: 100)
    
    var body: some View {
        Arrow()
            .frame(width: 60, height: 60)
            .rotationEffect(Angle(degrees:45))
            .foregroundColor(Color.green)
            .offset(x:100,y:100)
        
        Arrow()
            .frame(width: 60, height: 60)
            .rotationEffect(Angle(degrees:135))
            .foregroundColor(Color.red)
            .offset(x:-100,y:30)
        gears
            .resizable()
            .frame(width: 250, height: 250)
            .rotationEffect(Angle(radians: rotation))

            .offset(y:-30)
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
                        if rectangles.count > 8{
                            speed_transform = 50.0
                        }
                        pp = -180 + barv/(2*Double.pi)*speed_transform
                        gap = 1
                        gap *= Double(current_block)
                        
                        if (pp + 190.0) > Double((Double(current_block) + 1.0) * rectangles[0].width + gap ) {
                            if avil{
                                rectangles = change_color(list: rectangles, num: current_block)
                            }
                            current_block += 1
                        }
                        if pp > 180 {
                            pp = 180
                        }
                    }
                    .onEnded{ value in
                        isATriggered = false
                    }
            )
        
       

        ZStack {
            Text(date)
                .offset(x:0,y:10)
            ForEach(0 ..< rectangles.count, id:\.self) {id in
                Rectangle()
                    .frame(width: rectangles[id].width, height: 30)
                    .offset(x: rectangles[id].offset, y: -135)
                    .foregroundColor(rectangles[id].color)
                    .onTapGesture{
                        rectangles = reset_color(rect: rectangles, num: id)
                    }
                
                
            }
            
                //the last time mark
            ForEach(0..<num_rect) {id in
                Text(date_to_string(x: possible_time[current_index_on_possible_time].start.addingTimeInterval(Double(time_seg) * Double(id))))
                    .offset(x: rectangles[id].offset - rectangles[id].width/2, y: -110)
                    .font(.system(size: 12))
                
            }
                Text(date_to_string(x: possible_time[current_index_on_possible_time].start.addingTimeInterval(Double(time_seg) * Double(num_rect))))
                    .offset(x: rectangles[rectangles.count-1].offset + rectangles[rectangles.count-1].width/2, y: -110)
                    .font(.system(size: 12))
            pointer
//                .foregroundColor(Color.blue)
                .resizable()
                            .scaledToFit() // Maintain the aspect ratio of the image
                            .scaleEffect(0.07) // Adjust the scaling factor as needed
                            
                            .offset(x: pp, y:  -165)
            Text("Red: Unavailable, Green: Available\nTap the bar to change color")
                .offset(y:-35)
            Button(action: {
                print("Submitted")
                var is_green = false
                var start = 0
                for id in 0..<rectangles.count{
                    
                    if rectangles[id].color == Color.green {
                        if !is_green {start = id}
                        is_green = true
                        if id == rectangles.count - 1 {
                            list_time.append(DateInterval(start: possible_time[current_index_on_possible_time].start.addingTimeInterval(Double(time_seg) * Double(start)), duration: Double(time_seg * (id - start + 1))))
                        }
                    }
                    else if is_green {
                        is_green = false
                        list_time.append(DateInterval(start: possible_time[current_index_on_possible_time].start.addingTimeInterval(Double(time_seg) * Double(start)), duration: Double(time_seg * (id - start))))
                    }
                }
                //pass to api to delete the invite
                if current_index_on_possible_time < (possible_time.count - 1) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    date = dateFormatter.string(from: possible_time[current_index_on_possible_time].start)
                    current_index_on_possible_time += 1
                }else{
                    
                    let _:[String] = apipost(endpoint: "respond/", parameters: ["username": Config.username, "invite_id": String(invite_id), "times": encode_response(avail_times: possible_time)])
                    // feed the list_time back to the api.
                    current_index_on_possible_time = 0
                    
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

//let light_blue = Color(red: 0.6784, green: 0.847, blue: 0.902)
#Preview {
    Gear(invite_id: 1)
}
