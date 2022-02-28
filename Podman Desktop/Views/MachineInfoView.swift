//
//  MachineInfoView.swift
//  Podman
//
//  Created by Ashley Cui on 2/11/22.
//

import SwiftUI

struct MachineInfoView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var allMachines: AllMachines
    var body: some View {
        Group{
            Image("podman-large")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            Spacer()
        }
        Group{
        HStack{
            Text("Podman Virtual Machine")
                .font(.title)
            Spacer()
            Image("debug")
        }
        Divider()
        }
            .frame(width: 700)
    Spacer()
    Group{
        HStack{
            Spacer()
            VStack(alignment: .leading){
                HStack{
                    Text("Name: ")
                    Text(allMachines.activeMachine!.name)
                }
                HStack{
                    Text("VM Type: ")
                    Text(allMachines.activeMachine!.vmtype)
                
                }
                HStack{
                    Text("Created: ")
                    Text(allMachines.activeMachine!.created)
                }
            }
            Spacer()
            VStack(alignment: .leading){
                HStack{
                    Text("CPUs: ")
                    Text(String(allMachines.activeMachine!.cpus))
                }
                HStack{
                    Text("RAM: ")
                    Text(allMachines.activeMachine!.memory)
                
                }
                HStack{
                    Text("Disk Size: ")
                    Text(allMachines.activeMachine!.disksize)
                }
                }
            Spacer()
        }
    }
    .frame(width: 700)
    Spacer()
    
    Button("Use a different VM for podman machine"){
        viewRouter.currentPage = .machineSelect
    }
    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))

    
}
}

struct MachineInfoView_Previews: PreviewProvider {
    static var previews: some View {
        MachineInfoView()
    }
}
