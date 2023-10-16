//
//  NoteCardView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 06/06/23.
//

import SwiftUI

struct NoteCardView: View {
    var note: Note
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text(note.date, formatter: DateFormatter.noteCardFormatter)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.gray)
                    .padding(.trailing)
            }

            HStack{
                VStack(alignment: .leading){
                    Text(note.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(.bottom, 2)
                        .fixedSize(horizontal: false, vertical: true)
                    

                    Text(note.text)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color.black)
                        .padding([.bottom, .top, .trailing])
                        .fixedSize(horizontal: false, vertical: true)
                        
                }
                Spacer()
            }
            .padding([.bottom], 10)
            .padding([.leading, .trailing], 15)
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            //.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            
            HStack {
                Spacer()
                  VStack(alignment: .leading) {
                      Text(note.tag)
                          .frame(width: 180)
                          .foregroundColor(.white)
                          .padding(5)
                  }
                  .background(
                      RoundedRectangle(cornerRadius: 10)
                          .fill(
                              note.tag == "Información Personal" ? Color.orange :
                              note.tag == "Contacto" ? Color.red :
                              note.tag == "Historial Médico" ? Color.pink :
                              note.tag == "Diagnóstico" ? Color.purple :
                              note.tag == "Tratamiento" ? Color.yellow :
                              note.tag == "Soporte Familiar" ? Color.cyan :
                              note.tag == "Consentimientos" ? Color.green :
                              note.tag == "Contacto" ? Color.teal :
                              note.tag == "Otro" ? Color.black :  Color.clear
                          )
                  )
                  .frame(height: 30)
                  .cornerRadius(10)  // Applying cornerRadius to VStack
                  
              }
            .padding()
        }
    }
}


extension DateFormatter {
    static var noteCardFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
