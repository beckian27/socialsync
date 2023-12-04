//
//  CreateInvite.swift
//  socialsync
//
//  Created by Ian Beck on 11/2/23.
//

import SwiftUI

struct group: Codable, Hashable {
    let group_id: Int
    let group_name: String
    var members: [String]
}



    
struct GroupList: View {
    @State var myGroups: [group] = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Spacer()
            Spacer()
            NavigationLink(destination: CreateGroup()){
                Text("Create new group")
            }
            List(myGroups, id: \.self) { grp in
                NavigationLink(destination: CreateInvite(grp: grp)) {
                    Text(grp.group_name)
                }
            }
            .navigationBarTitle("Invite a Group")
        }
        .task {
            do {
                myGroups = try await performAPICall(endpoint: "/groups/")
            }
            catch {}
        }
    }
}

struct CreateInvite: View {
    var grp: group
    @State var displaytimes: [DateInterval] = []
    @State var date: Date = Date.now
    @State var endtime: Date = Date(timeIntervalSinceNow: 999999999999999)
    @State var event_name: String = ""
    @State var duration: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationStack {
            
            
            VStack (alignment: .leading) {
                
                Text("Create Event")
                    .font(.title)
                    .bold()
                Text("For: " + grp.group_name).bold()
//                ForEach(grp.members, id:\.self) { member in
//                    Text(member)
//                }
                Divider()
                Text("Potential Times:")
                
                ForEach(displaytimes, id: \.self) { time in
                    Text(time.start.formatted() + "-" + time.end.formatted(date:.omitted, time:.shortened))
                }
                Form{
                    
                    TextField("Event Name", text: $event_name)
                    TextField("Length (Hrs)", text: $duration)
                    Text("Propose timeslots:")
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                    DatePicker("Start", selection: $date, displayedComponents: [.hourAndMinute])
                        .onAppear {
                            UIDatePicker.appearance().minuteInterval = 30
                        }
                    DatePicker("End", selection: $endtime, displayedComponents: [.hourAndMinute])
                        .onAppear {
                            UIDatePicker.appearance().minuteInterval = 30
                        }
                    Button("Add Another Timeslot") {
                        let interval = DateInterval(start: date, end: endtime)
                        displaytimes.append(interval)

                    }
                    Button("Send!") {
                        let interval = DateInterval(start: date, end: endtime)
                        displaytimes.append(interval)
                        let times = Array(Set(displaytimes))
                        
                        let timestring = encode_response(avail_times: times)
                        Task{
                            
                            let _:[String] = apipost(endpoint: "create_invite", parameters: ["event_name": event_name, "avail_time": timestring, "host_name": Config.username, "group_id": String(grp.group_id), "image_name": "josh", "duration": String(Int(duration)! * 3600), "username": Config.username])
                            //                        do {
                            //                            let id:[idstruct] = try await performAPICall(endpoint: "get_id/")
                            //                            print(id)
                            //                        }
                            //                        catch{}
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .cornerRadius(15)
                
                .background(Color.clear)
            }
            .background(Color.back)
        
            
        }
        
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.back)
    }
}


struct CustomButton: View {
    var name: String
    @State private var didTap:Bool = false

    var body: some View {
        Button(name) {
        if self.didTap{
            if let index = newgroupmembers.firstIndex(of: name) {
                newgroupmembers.remove(at: index)
            }
        }
        else {
            newgroupmembers.append(name)
        }
        self.didTap.toggle()
        
    }
        
    .frame(maxHeight: 30)
    .tint(didTap ? Color.blue : Color.gray)
    }
}

var newgroupmembers: [String] = []

struct CreateGroup: View {
    @State var group_name = ""
    @State var friends: [MyFriend] = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        
        NavigationStack {
            Form {
                TextField("Group Name", text: $group_name)
            }.frame(maxHeight: 63)
            List{
                ForEach(friends, id:\.self) { friend in
                    CustomButton(name: friend.fullname)
                }
                Button("Create!"){
                    var members = ""
                    for member in newgroupmembers{
                        members += member + ","
                    }
                    members += Config.username
                    let _:[String] = apipost(endpoint: "create_group/", parameters: ["group_name": group_name, "members": members])
                        dismiss()
                }
            }
        }
        .task {
            do {
                friends = try await performAPICall(endpoint: "/friends/")
                newgroupmembers = []
            }
            catch{}
        }
    }
}

#Preview {
    CreateInvite(grp: group(group_id: 1, group_name: "theboys", members: ["joe"]))
}
