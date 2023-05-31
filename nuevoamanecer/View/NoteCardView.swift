//
//  NoteCardView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 30/05/23.
//
/*
import SwiftUI

struct NoteCardView: View {
    
    @State var note: Note
    @State var showEditNoteView: Bool
    @State var showDeleteNoteAlert: Bool
    @State var selectedNote: Note?
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(note.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color.black)
                        .padding(.bottom, 2)
                    Text(note.text)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color.gray)
                        .padding([.bottom, .top, .trailing])
                        
                }
                Spacer()
            }
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 15)
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            //.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .frame(minHeight: 150)
        .padding([.top, .bottom], 5)
        .swipeActions(edge: .trailing) {
            Button {
                selectedNote = note
                showDeleteNoteAlert = true
            } label: {
                Label("Eliminar", systemImage: "trash")
            }
            .tint(.red)
            .padding()
            
            Button {
                // Aquí va la lógica para actualizar la nota
                selectedNote = note
                showEditNoteView = true
            } label: {
                Label("Editar", systemImage: "pencil")
            }
            .tint(.blue)
            .padding()
        }
    }
}

struct NoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        NoteCardView(note: Note(id: "", patientId: "", order: 0, title: "", text: ""), showEditNoteView: false, showDeleteNoteAlert: false, selectedNote: Note(id: "", patientId: "", order: 0, title: "", text: ""))
    }
}
*/
