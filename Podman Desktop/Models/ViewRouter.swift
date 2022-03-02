//
//  ViewRouter.swift
//  Podman Desktop
//
//  Created by Ashley Cui on 1/28/22.
//

import Foundation


class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .land
    @Published var statefulError: Error? = nil
    
}

enum Page {
    case noPodman
    case land
    case settings
    case machineSelect
    case machineInit
}
