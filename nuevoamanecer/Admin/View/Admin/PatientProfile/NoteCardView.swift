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
            
            HStack{
                VStack(alignment: .leading){
                    Text(note.tag)
                        .cornerRadius(10)
                        .frame(width: 200)
                        .foregroundColor(.white)
                        .background(
                            note.tag == "Información Personal" ? Color.orange :
                            note.tag == "Contacto" ? Color.red :
                            note.tag == "Historial Médico" ? Color.pink :
                            note.tag == "Diagnóstico" ? Color.purple :
                            note.tag == "Tratamiento" ? Color.yellow :
                            note.tag == "Soporte Familiar" ? Color.cyan :
                            note.tag == "Concentimientos" ? Color.green :
                            note.tag == "Contacto" ? Color.teal :
                            note.tag == "Otro" ? Color.black :  Color.clear
                        )
                        .padding(10)
                        
                }
                .cornerRadius(10)
                Spacer()
            }
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

struct NoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        NoteCardView(note: Note(id: "", patientId: "", order: 0, title: "", text: "", date: Date(), tag: ""))
    }
}
