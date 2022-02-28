//
//  SettingsView.swift
//  Podman Desktop
//
//  Created by Ashley Cui on 12/9/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var allMachines: AllMachines
    var body: some View {
        VStack {
            Group{
                ZStack{
                    Color.white
                    HStack{
                        Text("Settings")
                            .multilineTextAlignment(.leading)
                            .font(.title2)
                        Spacer()
                        Button(action: {
                            viewRouter.currentPage = .land
                                    }){
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.gray)
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding(.trailing)
                                    .opacity(1)
                                    .buttonStyle(PlainButtonStyle())

                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }

                .frame(height: 50, alignment: .leading)
            }
            if allMachines.activeMachine != nil{
                Spacer()
            MachineInfoView()
                    .environmentObject(allMachines)
                    .environmentObject(viewRouter)
            } else {
                NoMachineView()
                    .environmentObject(allMachines)
                    .environmentObject(viewRouter)
            }
            HStack{
                Link("Visit the Podman Website", destination: URL(string: "https://podman.io")!)
                    .padding()
                Link("Join the Podman Community", destination: URL(string: "https://podman.io/community")!)
                    .padding()

                Link("Report a Problem", destination: URL(string: "https://github.com/containers/podman-desktop/issues")!)
                    .padding()

            }
        .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let situations: [(name: String, allMachines: AllMachines)] = [
            ("Running", AllMachines.previewWithOneRunningMachine()),
            ("Stopped", AllMachines.previewWithOneStoppedMachine()),
            // Currently crashes
            // ("No machine", AllMachines.previewWithNoMachines()),
        ]
        ForEach(situations, id: \.name) { s in
            SettingsView()
                .environmentObject(s.allMachines)
                .environmentObject(ViewRouter())
                .previewDisplayName(s.name)
        }
    }
}
