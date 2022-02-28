//
//  MachineInitView.swift
//  Podman Desktop
//
//  Created by Ashley Cui on 12/18/22.
//

import SwiftUI

struct MachineSelectView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var allMachines: AllMachines
    @State private var chosenVM = ""

    @State private var machineIndex = 0

    var body: some View {
        Group{
        Form {
                Picker("Select a machine", selection: $machineIndex) {
                    ForEach(0..<allMachines.lst.count) { index in
                        Text(self.allMachines.lst[index].name)
                    }
                }
                .frame(width: 500)
                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
            }
            HStack{
                Button("Set Machine"){
                    allMachines.setActiveMachine(machine: allMachines.lst[machineIndex])
                    viewRouter.currentPage = .settings
                }
        Button("Cancel"){
            viewRouter.currentPage = .settings
        }
            }
            .padding()
            Button("Create new VM"){
                viewRouter.currentPage = .machineInit
            }
        }
        .frame(width: 700)
    }
}

struct MachineSelectView_Previews: PreviewProvider {
    static var previews: some View {
        let situations: [(name: String, allMachines: AllMachines)] = [
            ("Standard", AllMachines.previewWithSeveralMachines()),
            // Currently crashes
            // ("No machine", AllMachines.previewWithNoMachines()),
        ]
        ForEach(situations, id: \.name) { s in
            VStack {
                MachineSelectView()
            }
            .environmentObject(s.allMachines)
            .environmentObject(ViewRouter())
            .previewDisplayName(s.name)
        }
    }
}
