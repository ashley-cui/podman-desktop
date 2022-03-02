//
//  Errors.swift
//  Podman Desktop
//
//  Created by Ashley Cui on 1/25/22.
//

import Foundation


enum MachineStartError: Error {
    case machineNotExist
    case alreadyRunning
    case genericError(reason: String)
    
}


enum MachineInitError: Error {
    case invalidCPUs
    case invalidIgnition
    case invalidImage
    case invalidDisk
    case invalidMemory
    case machineExists
    case genericError(reason: String)
}

enum MachineStop: Error {
    case genericError(reason: String)
    
}

func parseMachineStart(message: String) -> Error{
    switch message {
    case let str where str.contains("VM does not exist"):
        return MachineStartError.machineNotExist
    case let str where str.contains("VM already running"):
        return MachineStartError.alreadyRunning
    default:
        return MachineStartError.genericError(reason: message)
    }
}

func parseMachineInitError(message: String) -> Error{
    switch message {
    case let str where str.contains("VM already exists"):
        return MachineInitError.machineExists
    case let str where str.contains("cpus"):
        return MachineInitError.invalidCPUs
    case let str where str.contains("disk-size"):
        return MachineInitError.invalidDisk
    case let str where str.contains("ignition-path"):
        return MachineInitError.invalidIgnition
    case let str where str.contains("image-path"):
        return MachineInitError.invalidImage
    case let str where str.contains("memory"):
        return MachineInitError.invalidMemory
    default:
        return MachineStartError.genericError(reason: message)
    }
}

struct ErrorAlert: Identifiable {
    var id = UUID()
    var message: String
    var dismissAction: (() -> Void)?
}

class ErrorHandling: ObservableObject {
    @Published var currentAlert: ErrorAlert?

    func handle(error: Error) {
        currentAlert = ErrorAlert(message: error.localizedDescription)
    }
}
