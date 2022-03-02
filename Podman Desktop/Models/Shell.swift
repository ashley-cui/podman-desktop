//
//  ModelData.swift
//  Podman Desktop
//
//  Created by Ashley Cui on 11/24/21.
//

import Foundation


func shell(arguments: [String]) throws ->  (Int32, String){
    var str=""
    let process = Process()
    let pipe = Pipe()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = arguments
    process.standardOutput = pipe
    process.standardError = pipe
    var environment =  ProcessInfo.processInfo.environment
    
        environment["PATH"] = (environment["PATH"] ?? "")+":/opt/homebrew/bin/:/usr/local/bin/"
        process.environment = environment
    do {
        try process.run()
    }
    catch{
        throw error }

    let outHandle = pipe.fileHandleForReading
    // TODO: manage output readability better here
    outHandle.readabilityHandler = { pipe in
        if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
            str+=line
        }
    }


    process.waitUntilExit()
    let status = process.terminationStatus
    // remove the trailing new-line char
    print(arguments)
    return (status, str)
}

func machineList() throws -> (Int32, String){
    return try shell(arguments: ["podman","machine", "list", "--format", "json"])
}

func machineInit(mach: NewMachineInit) throws{
    print("here!")
    var args = ["podman","machine", "init", "--cpus", String(mach.cpus), "--memory", String(mach.memory), "--disk-size", String(mach.disksize)]
    
    args.append("--ignition-path")
    if mach.useFcos{
        args.append(mach.fcosStream)
    } else {
        args.append(mach.imagePath)
    }
    

    if !mach.defaultIgn && mach.ignitionPath != ""{
        args.append("--image-path")
        args.append(mach.ignitionPath)
    }
    args.append(mach.name)
    
    do{
        try shell(arguments: args)
    }
    catch{
        print("elelle")
    }
}

