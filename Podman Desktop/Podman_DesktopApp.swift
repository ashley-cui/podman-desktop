//
//  Podman_DesktopApp.swift
//  Podman Desktop
//
//  Created by Ashley Cui on 11/9/21.
//

import SwiftUI
import Foundation
@main
struct Podman_DesktopApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
//        var filePath = "/Users/acui/go/src/github.com/containers/podman/bin/darwin"
//        let fileManager = FileManager.default
//        // Check if file exists
//        if fileManager.fileExists(atPath: filePath) {
//            print("File exists")
//        } else {
//            print("File does not exist")
//        }
    }
    var allMachines = AllMachines()
    
        
    var body: some Scene {
        Settings {
            EmptyView()
                }
        WindowGroup("Viewer") { // other scene
//                    TestView()
            ContentView()
                .environmentObject(allMachines)
//            SettingsView()
                }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover.init()
        var statusBar: StatusBarController?
    
        func applicationDidFinishLaunching(_ aNotification: Notification) {
//            if let window = NSApplication.shared.windows.first {
//                   window.close()
//               }
            // Create the SwiftUI view that provides the contents
            let contentView = MenuBar()

            // Set the SwiftUI's ContentView to the Popover's ContentViewController
            popover.contentSize = NSSize(width: 220, height: 200)
            popover.contentViewController = NSHostingController(rootView: contentView)
            
            // Create the Status Bar Item with the above Popover
            statusBar = StatusBarController.init(popover)
//            Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
//                   if self.window.isVisible {
//                       NSApp.hide(self)
//                   } else {
//                       NSApp.unhide(self)
//                   }
//        }

        func applicationWillTerminate(_ aNotification: Notification) {
            //teardown
        }
        
        }
//    var window: NSWindow!
//       var preferencesWindow: NSWindow!
//
//       @objc func openPreferencesWindow() {
//           if nil == preferencesWindow {
//               let preferencesView = ContentView()
//               preferencesWindow = NSWindow(
//                   contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
//                   styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
//                   backing: .buffered,
//                   defer: false)
//               preferencesWindow.center()
//               preferencesWindow.setFrameAutosaveName("Preferences")
//               preferencesWindow.isReleasedWhenClosed = false
//               preferencesWindow.contentView = NSHostingView(rootView: preferencesView)
//           }
//           preferencesWindow.makeKeyAndOrderFront(nil)
//       }
}
