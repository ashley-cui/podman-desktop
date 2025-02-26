//
//  File.swift
//  Podman Desktop
//
//  Created by Ashley Cui on 11/17/21.
//

import Foundation
import SwiftUI

struct Machine: Hashable, Codable {
    var name: String
    var dflt: Bool
    var created: String
    var running: Bool
    var lastup: String
    var stream: String
    var vmtype: String
    var cpus: Int
    var memory: String
    var disksize: String
    var port: Int
    var remoteUsername: String
    var identityPath: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case dflt = "Default"
        case created = "Created"
        case running = "Running"
        case lastup = "LastUp"
        case stream = "Stream"
        case vmtype = "VMType"
        case cpus = "CPUs"
        case memory = "Memory"
        case disksize = "DiskSize"
        case port = "Port"
        case remoteUsername = "RemoteUsername"
        case identityPath = "IdentityPath"

    }
}

class AllMachines: ObservableObject{
    @Published var lst: [Machine]
    @Published var activeMachine: Machine?
    @Published var defaultConnection: Bool
    @Published var running: Bool
    @Published var runningString: String
    @Published var noMachines: Bool
    // TODO: check if warn if active machine is not default connection
    // TODO: check if no machines exist
    
    /// Set to `listMachinesFromPodman` on real runs, only exists to support unit tests and previews.
    private let machineListRetriever: () throws -> [Machine]
    
    /// Create a new observer of the Podman machine set.
    /// - Parameter machineListRetriever: A non-default provider of the machine state, intended only to support unit tests and previews.
    init(machineListRetriever: @escaping () throws -> [Machine] = listMachinesFromPodman) {
        self.machineListRetriever = machineListRetriever
        self.lst=[]
        activeMachine = nil
        defaultConnection = false
        running = false
        runningString = "not running"
        noMachines = false
    }
    
    private static func listMachinesFromPodman() throws -> [Machine]  {
        let output = try machineList()
        let jsonData = output.1.data(using: .utf8)!
        return try! JSONDecoder().decode([Machine].self, from: jsonData)
    }
    
    func loadLst(){
        var jsons = [Machine]()
        do {
            jsons = try self.machineListRetriever()
        }
        catch {
            print("\(error)") // TODO: plumb custom errors
        }
        self.lst=jsons
    }
    func getRunning() -> Machine?{
        for mach in self.lst{
            if mach.running{
                return mach
            }
        }
        return nil
    }

    func isRunning() -> Bool?{
        return activeMachine?.running
    }

    func getMachine(name: String) -> Machine?{
       for mach in self.lst{
           if mach.name == name{
               return mach
           }
       }
       return nil
   }

    func getCLIDefault() -> Machine?{
        for mach in self.lst{
            if mach.dflt{
                return(mach)
            }
        }
        return(nil)
    }

    func reloadAll(){
        loadLst()
        loadActiveMachine()
        checkDefaultConnection()
        loadRunning()

    }

    func loadRunning() {
        running = activeMachine?.running ?? false // Should we have an extra state to represent “N/A, no machine exists”?
        runningString = running ? "running" : "not running"
    }
    func loadActiveMachine() {
            // 1. Active machine is running

            // No machines are running, so no active machine.
            if lst.count == 0{
                activeMachine = nil
                return
            }
            // If a machine is running, it is ALWAYS the active machine
            let runningMachine = getRunning()
            if runningMachine != nil{
                setActiveMachine(machine: runningMachine!)
                return
            }

            // Check which machine was active last, that is the active machine
            let lastRunName = UserDefaults.standard.string(forKey: "activeName")
            if lastRunName != nil{
                // Check if cached machine name actually still exists
                let maybeMachine = getMachine(name: lastRunName!)
                if maybeMachine == nil{
                    // Cached last active no longer exists, clear
                    UserDefaults.standard.set("", forKey: "activeName")
                } else {
                    setActiveMachine(machine: maybeMachine!)
                    return
                }
            }
            // CLI default machine is the active machine
            let cliDef = getCLIDefault()
            if cliDef != nil {
                setActiveMachine(machine: cliDef!)
                return
            }
            // No previously active machine, just choose the first machine on the list
            setActiveMachine(machine: lst[0])
            return
    }

    func setActiveMachine(machine: Machine){
        activeMachine = machine
        UserDefaults.standard.set(machine.name, forKey: "activeName")
    }

    func changeActiveMachine(machine: Machine){
        activeMachine = machine
        UserDefaults.standard.set(activeMachine!.name, forKey: "activeName")
    }

    func checkDefaultConnection(){
        if activeMachine == nil{
            defaultConnection = false
            return
        }
        defaultConnection = activeMachine!.dflt
    }
    
    func startActive() async throws -> Int32{
        reloadAll()
        let output = try shell(arguments: ["podman","machine", "start", activeMachine!.name])
        return output.0
    }
    
    func stopActive() async throws -> Int32{
        reloadAll()
        let output = try shell(arguments: ["podman","machine", "stop", activeMachine!.name])
        return output.0
    }

}

    
class NewMachineInit: ObservableObject {
    @Published var name: String
    @Published var ignitionPath: String
    @Published var imagePath: String
    @Published var cpus: Int
    @Published var memory: Int
    @Published var disksize: Int


    init(){
        self.name = "new_machine"
        self.ignitionPath=""
        self.imagePath="next"
        self.cpus=1
        self.memory=2040
        self.disksize=10
    }
    func validate(){
        //TODO: validate

    }
    func create() throws {
        do {
            try machineInit(mach:self)

        }
        catch {
            print("\(error)") // TODO: plumb custom errors
        }
    }
}

// Fake AllMachines data only to make it easy to show realistic previews.
extension AllMachines {
    static private func fakeMachine(name: String, isRunning: Bool = false, isDefault: Bool = false) -> Machine {
        // Use more realistic data?
        Machine(name: name, dflt: isDefault, created: "TODO", running: isRunning, lastup: "TODO", stream: "TODO", vmtype: "TODO", cpus: 1, memory: "TODO", disksize: "TODO", port: 8888, remoteUsername: "TODO", identityPath: "TODO")
    }

    static private func previewWithData(_ data: [Machine]) -> AllMachines {
        let res = AllMachines(machineListRetriever: { return data })
        // Currently, creating an AllMachines() does not trigger actually loading the data.
        // In real runs, that is only triggered when the top-level ContentView appears;
        // for previews of individual views, we need to trigger the refresh explicitly.
        res.reloadAll()
        return res
    }

    static func previewWithNoMachines() -> AllMachines {
        return previewWithData([Machine]())
    }

    static func previewWithOneRunningMachine() -> AllMachines {
        return previewWithData(
            [fakeMachine(name: "fedora", isRunning: true)]
        )
    }

    static func previewWithOneStoppedMachine() -> AllMachines {
        return previewWithData(
            [fakeMachine(name: "fedora", isRunning: false)]
        )
    }

    static func previewWithSeveralMachines() -> AllMachines {
        return previewWithData(
            [
                fakeMachine(name: "ubuntu"),
                fakeMachine(name: "fedora-running", isRunning: true),
                fakeMachine(name: "centos-default", isDefault: true),
                fakeMachine(name: "rhel"),
            ]
        )
    }
}
