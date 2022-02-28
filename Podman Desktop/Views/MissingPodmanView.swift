//
//  MissingPodmanView.swift
//  Podman
//
//  Created by Ashley Cui on 2/10/22.
//

import SwiftUI
import AppKit

struct MissingPodmanView: View {
    var body: some View {
        VStack{
        Spacer()
        Image("selkie-artwork")
            .resizable()
            .scaledToFit()
            .frame(width: 150)
            Text("Podman binary not found")
                .font(.title)
                .padding()
            Text("Looks like you don't have the Podman binary installed. Please install it using")
                .multilineTextAlignment(.center)
            HStack{

                Text("$ brew install podman")
                    .textSelection(.enabled)
                    .foregroundColor(.white)
                    .frame(width: 250, height: 30)
                    .background(.gray)
                    .cornerRadius(10)
                Button(action: {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString("brew install podman", forType: .string)
                            }){
                                Image(systemName: "doc.on.doc")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.trailing)
                            .opacity(1)
                            .buttonStyle(PlainButtonStyle())
            }
            .padding()
            Spacer()
            Button("Already have Podman installed?"){
                print("jsdjfhkjaskdf")
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.blue)
            Spacer()
        }
    }
}






struct MissingPodmanView_Previews: PreviewProvider {
    static var previews: some View {
        MissingPodmanView()
    }
}
