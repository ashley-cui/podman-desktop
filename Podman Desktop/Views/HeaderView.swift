//
//  Header.swift
//  Podman Desktop
//
//  Created by Ashley Cui on 12/2/21.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        ZStack {
                   Color("podman-purple")
                       .ignoresSafeArea()
                   
            ZStack{
                Image("podman-1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                MachineControls()
            }
        }
    }
}
//
struct MachineControls: View{

    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var allMachines: AllMachines
    @State var starting: Bool = false
    @State var isPopover = false
    @State var errorImgName = "exclamationmark.triangle"
    var body: some View{


        HStack{
            Spacer()
            if allMachines.activeMachine == nil {
            Button(action: { self.isPopover.toggle() }) {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.yellow)
                    .frame(width: 20, height: 20)
            }.popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                     DefaultConnectionView()
            }.buttonStyle(PlainButtonStyle())
            }
            Text("Podman is:")
                .foregroundColor(.gray)
            if starting{
            Text("starting")
                .foregroundColor(.white)
                ProgressView()
            } else{
                Text (allMachines.runningString)
                .foregroundColor(.white)
            }
            Button {
                allMachines.reloadAll()
                if !allMachines.running{
                    Task{
                        starting = true
                        do {
                            var exitcode = try await allMachines.startActiveAsync()
                            allMachines.reloadAll()
                            starting = false
                        }
                    catch {print("error")} // TODO: plumb custom errors
                    }
                    
                } else {
                    Task{
                    do {try await allMachines.stopActive()
                        allMachines.reloadAll()
                    }
                    catch {print("error")} // TODO: plumb custom errors
                    }
                }
            } label: {
                Image(systemName: "power.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(allMachines.running ? .green : .white, allMachines.running ? .white : .purple )
                    .frame(width: 25, height: 25)
            }
            .padding(.trailing)
            
            Button(action: {
                if viewRouter.currentPage == .land{
                    viewRouter.currentPage = .settings
                }else{
                    viewRouter.currentPage = .land
                }
                        }){
                            Image(systemName: "gearshape")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                        }
                        .padding(.trailing)
                        .opacity(1)

        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DefaultConnectionView: View {
    var body: some View {
        VStack {
            Text("Running machine is not default Podman connection")
            .padding()
            .multilineTextAlignment(.center)
            .frame(width: 200, alignment: .center)
            Button("Learn More") {
            }
        }.padding()
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let situations: [(name: String, allMachines: AllMachines)] = [
            ("Running", AllMachines.previewWithOneRunningMachine()),
            ("Stopped", AllMachines.previewWithOneStoppedMachine()),
            ("No machine", AllMachines.previewWithNoMachines()),
        ]
        ForEach(situations, id: \.name) { s in
            HeaderView()
                .environmentObject(s.allMachines)
                .environmentObject(ViewRouter())
                .previewDisplayName(s.name)
        }
    }
}
