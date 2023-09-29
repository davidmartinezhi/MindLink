//
//  CommunicatorMenuView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 09/06/23.
//

import SwiftUI

struct CommunicatorMenuView: View {
    var patient: Patient

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Comunicador")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(patient.firstName)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                }
                .padding()

                Button(action: {
                    // Acción para el comunicador
                }) {
                    Text("Comunicador")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding([.leading, .trailing], 20)

                Button(action: {
                    // Acción para el editor de comunicador
                }) {
                    Text("Editor de comunicador")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding([.leading, .trailing, .bottom], 20)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
