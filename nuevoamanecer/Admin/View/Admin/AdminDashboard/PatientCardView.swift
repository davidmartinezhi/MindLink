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
    
    //obtiene edad del paciente
    private func getAge(patient: Patient) -> Int {
        let birthday: Date = patient.birthDate // tu fecha de nacimiento aquí
        let calendar: Calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: birthday, to: Date())
        let age = ageComponents.year!
        
        return age
    }
    
    var body: some View{
        VStack(alignment: .leading) {
            HStack {
                if(patient.image == "placeholder") {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.trailing)
                } else {
                    KFImage(URL(string: patient.image))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.trailing)
                }
                
                VStack(alignment: .leading) {
                    
                    HStack{
                        Text(patient.firstName + " " + patient.lastName)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color.black)
                            .padding(.vertical, 1)
                        
                        Text(String(getAge(patient: patient)) + " años" )
                            .font(.headline)
                           .foregroundColor(Color.gray)
                           .padding(.vertical, 1)
                    }

                    
                    VStack(alignment: .leading){
                        Text("Grupo: " + patient.group)
                            .font(.headline)
                            .foregroundColor(Color.gray)
                            .padding(.trailing)
                            .padding(.vertical,1)
                        
                        Text("Nivel Cognitivo: " + patient.cognitiveLevel)
                            .font(.headline)
                            .foregroundColor(Color.gray)
                            .padding(.trailing)
                            .padding(.vertical,1)
                        
                        Text("Comunicación: " + patient.communicationStyle)
                            .font(.headline)
                            .foregroundColor(Color.gray)
                            .padding(.trailing)
                            .padding(.vertical,1)
                    }
                    
                }
                .padding(.leading)
                
                Spacer()
                /*
                Button(action: {
                    print("Comunicador")
                }) {
                    HStack {
                        Image(systemName: "message.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Comunicador")
                            .font(.headline)

                    }
                    
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                */
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
