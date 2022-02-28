//
//  MachineInitView.swift
//  Podman Desktop
//
//  Created by Ashley Cui on 12/18/22.
//

import SwiftUI

struct MachineInitView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var allMachines: AllMachines
    @ObservedObject var newMachine = NewMachineInit()
    var streams = ["stable", "testing", "next"]
    @State private var focsStream = "next"
    @State private var ignFile = ""
    @State var imgFile = ""

    var memoryToInt: Binding<Double>{
            Binding<Double>(get: {
                //returns the score as a Double
                return Double(newMachine.memory)
            }, set: {
                //rounds the double to an Int
                newMachine.memory = Int($0)
            })
        }
    
    var diskToInt: Binding<Double>{
            Binding<Double>(get: {
                //returns the score as a Double
                return Double(newMachine.disksize)
            }, set: {
                //rounds the double to an Int
                newMachine.disksize = Int($0)
            })
        }

    var body: some View {
        Group{
            ZStack{
                Color.white
                HStack{
                    Text("Create a new VM")
                        .multilineTextAlignment(.leading)
                        .font(.title2)
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .frame(height: 50, alignment: .leading)
        }
        Spacer()
        VStack{
            VStack{
                HStack(alignment: .firstTextBaseline){
                    Text("Machine Name")
                        .frame(width:100)
                    VStack{
                        TextField(
                            "VM Name",
                            text: $newMachine.name
                        )
                        if newMachine.nameErr{
                            HStack{
                            Text("Machine with name already exists")
                                    .foregroundColor(.red)
                            Spacer()
                        }
                        }
                    }
                }
//                if newMachine.nameErr{
            }
            
            HStack(alignment: .firstTextBaseline){
                Text("CPUs")
                    .frame(width:100)
                    HStack{
                        TextField(
                            "CPUs",
                            value: $newMachine.cpus,
                            format: .number
                        )
                            .frame(width: 25)
                        Stepper("",value: $newMachine.cpus)
                        Spacer()
                    }
            }
            
            HStack(alignment: .firstTextBaseline){
                Text("RAM")
                    .frame(width:100)
                        TextField(
                            "Memory",
                            value: $newMachine.memory,
                            format: .number
                        )
                            .frame(width: 65)
                            
                        Text("MB")
                        Slider.ln(value: memoryToInt, in: 1 ... 65536)
            }
            
            HStack(alignment: .firstTextBaseline){
                Text("Disk size")
                    .frame(width:100)
            
                TextField(
                    "Disk size",
                    value: $newMachine.disksize,
                    format: .number
                )
                    .frame(width: 65)
                Text("GB")
                Slider.ln(value: diskToInt, in: 16 ... 2048)

            }
            
            HStack(alignment: .firstTextBaseline){
                Text("VM OS")
                    .frame(width:100)
                VStack{
                    Picker("", selection: $newMachine.useFcos) { // <2>
                        HStack{
                            Text("Fedora CoreOS") // <3>
                            Picker("",selection: $newMachine.fcosStream) {
                                               ForEach(streams, id: \.self) {
                                                   Text($0)
                                               }
                                           }
                            .disabled(!newMachine.useFcos)
                                           .pickerStyle(SegmentedPickerStyle())
                        }.tag(true)

                        HStack{
                            Button("Upload Custom Image"){
                                let panel = NSOpenPanel()
                                panel.allowsMultipleSelection = false
                                panel.canChooseDirectories = false
                                if panel.runModal() == .OK {
                                   self.imgFile = panel.url?.path ?? ""
                                    newMachine.imagePath=self.imgFile
                                }
                            }
                            .disabled(newMachine.useFcos)
                            Text(imgFile)
                                .frame(width: 250, height: 10)
                                .truncationMode(.head)
                        }.tag(false)
                    }
                    .pickerStyle(RadioGroupPickerStyle())
                    if newMachine.imageErr{
                        HStack{
                            Text("Invalid image path")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }

            }
            
            HStack(alignment: .firstTextBaseline){
                Text("Ignition Path")
                    .frame(width:100)
                VStack{
                    Picker("", selection: $newMachine.defaultIgn) { // <2>
                                Text("Generate Default") // <3>
                                    .tag(true)
                            HStack{
                                Button("Upload Custom Ignition"){
                                    let panel = NSOpenPanel()
                                    panel.allowsMultipleSelection = false
                                    panel.canChooseDirectories = false
                                    if panel.runModal() == .OK {
                                       self.ignFile = panel.url?.path ?? ""
                                    }
                                }
                                .disabled(newMachine.defaultIgn)
                                Text(ignFile)
                                    .frame(width: 200, height: 10)
                                    .truncationMode(.head)
                                    .foregroundColor(newMachine.defaultIgn ? .gray : .black)
                            }.tag(false)
                        }
                        .pickerStyle(RadioGroupPickerStyle())
                    if newMachine.ignitionErr{
                        HStack{
                            Text("Invalid ignition path")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            HStack{
                Button("Cancel"){
                    viewRouter.currentPage = .machineSelect
                }
                Button("Create") {
                    if newMachine.validate(existing: allMachines.lst){
                               // TODO: need to validate data, make sure no fields are emptyhere
                        do{
                            try newMachine.create()
                            allMachines.reloadAll()
                        } catch {
                            print("error") // TODO: plumb custom errors
                        }
                        viewRouter.currentPage = .machineSelect
                    }
                    
                }
            }
            .padding(40)
        }
        .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
        .frame(width: 500)
        Spacer()
    }
}


struct MachineInitView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MachineInitView()
        }
        .environmentObject(AllMachines.previewWithOneRunningMachine())
        .environmentObject(ViewRouter())
    }
}


extension Binding where Value == Double {
    func logarithmic(base: Double = 2) -> Binding<Double> {
        Binding(
            get: {
                log2(self.wrappedValue) / log2(base)
            },
            set: { (newValue) in
                self.wrappedValue = pow(base, newValue)
            }
        )
    }
}

extension Slider where Label == EmptyView, ValueLabel == EmptyView {

    static func ln(
        value: Binding<Double>,
        in range: ClosedRange<Double>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) -> Slider {
        return self.init(
            value: value.logarithmic(),
            in: log2(range.lowerBound) ... log2(range.upperBound),
            step: 1,
            onEditingChanged: onEditingChanged
        )
    }
}
