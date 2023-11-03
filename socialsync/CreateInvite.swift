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
    var times: [String] = []
    @State var starttime: String = "21:00"
    @State var endtime: String = "23:00"
    @State var date: String = "10/27/2023"
    @State var temp1: String = ""
    @State var temp2: String = ""

    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        NavigationStack {
            
            
            VStack (alignment: .leading) {
                Text("Creating an event for")
                    .font(.title)
                Text(grp.group_name + ":")
                ForEach(grp.members, id:\.self) { member in
                    Text(member)
                }
                
                
                
                
                Divider()
                
                Form {
                    TextField("Event Name", text: $temp1)
                    TextField("Length (Hrs)", text: $temp2)
                    Text("Propose timeslots:")
                    TextField("Date mm/dd/yyyy", text: $date)
                    TextField("Start", text: $starttime)
                    TextField("End", text: $endtime)

                    Button("Another timeslot") {}
                    Button("Send!") {                            presentationMode.wrappedValue.dismiss()
}
                }
//                List(inputs) { form in
//                    form
//                }
//                inputs[0]
//                invite_form(id:2)
                
                
                
                .padding()
                
            }
         
            
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CreateGroup: View {
    var body: some View {
        Text("h")
    }
}

#Preview {
    CreateInvite(grp: group(group_id: 1, group_name: "theboys", members: ["joe"]))
}
