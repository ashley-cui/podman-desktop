//
//  NoMachineView.swift
//  Podman
//
//  Created by Ashley Cui on 2/11/22.
//

import SwiftUI

struct NoMachineView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var allMachines: AllMachines
    var body: some View {
        VStack{
        Image("selkie-artwork")
            .resizable()
            .scaledToFit()
            .frame(width: 150)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            Text("No Machines Found")
                .font(.title)
                .padding()
            Text("You'll need to create a new machine to start Podman")
                .multilineTextAlignment(.center)
            Button("Use a different VM for podman machine"){
                Text("dskjaf")
            }
        }
        }

}

struct NoMachineView_Previews: PreviewProvider {
    static var previews: some View {
        NoMachineView()
    }
}
