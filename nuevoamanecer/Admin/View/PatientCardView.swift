//
//  PatientCardView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 06/06/23.
//

import SwiftUI
import Kingfisher

struct PatientCardView: View {
    
    let patient: Patient
    
    var body: some View{
        VStack(alignment: .leading) {
            HStack {
                KFImage(URL(string: patient.image))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                //.overlay(Circle().stroke(Color.gray, lineWidth: 2))
                //.cornerRadius(16.0)
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text(patient.firstName + " " + patient.lastName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    VStack(alignment: .leading){
                        Text("Grupo: " + patient.group)
                            .font(.headline)
                            .foregroundColor(Color.gray)
                            .padding(.trailing)
                            .padding(.vertical,2)
                        Text("Nivel Cognitivo: " + patient.cognitiveLevel)
                            .font(.headline)
                            .foregroundColor(Color.gray)
                            .padding(.trailing)
                            .padding(.vertical,2)
                        Text("Comunicación: " + patient.communicationStyle)
                            .font(.headline)
                            .foregroundColor(Color.gray)
                            .padding(.trailing)
                            .padding(.vertical,2)
                    }
                    
                }
                .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    print("Comunicador")
                }) {
                    Text("Comunicador")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 5)
    }
}
struct PatientCardView_Previews: PreviewProvider {
    static var previews: some View {
        PatientCardView(patient: Patient(id:"",firstName: "",lastName: "",birthDate: Date.now, group: "", communicationStyle: "", cognitiveLevel: "", image: "", notes:[String]()))
    }
}
