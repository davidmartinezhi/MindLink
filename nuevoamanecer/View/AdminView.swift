//
//  AdminView.swift
//  nuevoamanecer
//
//  Created by Gerardo Martínez on 19/05/23.
//

import SwiftUI
import Kingfisher

struct AdminView: View {
    
    @StateObject var patients = PatientsViewModel()
    
    @State var searchText = ""
    @State var isSearching = false
    @State private var showAddPatient = false
    
    var body: some View {
        NavigationView{
            VStack {
                // Search bar and Add Patient button
                HStack {
                    SearchBar(searchText: $searchText, isSearching: $isSearching)
                        .padding(.horizontal)
                    Button(action: {
                        showAddPatient = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                    }
                    .sheet(isPresented: $showAddPatient){
                        AddPatientView(patients: patients)
                    }
                    .padding(.trailing)
                }
                
                
                // Patient cards
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(minimum: 150))], spacing: 12) {
                        ForEach((patients.patientsList).filter({"\($0)".contains(searchText) || searchText.isEmpty}), id: \.self){ patient in
                            PatientCard(patient: patient)
                            Divider()
                                .background(Color(.systemGray2))
                                .padding(.leading)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 60)
            }
            //.navigationTitle("Admin Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    /*
                    Button(action: {
                        showAddPatient = true
                    }) {
                        Image(systemName: "plus")
                    }
                     */
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

struct PatientCard: View {
    
    let patient: Patient
    
    var body: some View{
        VStack(alignment: .leading) {
            HStack {
                KFImage(URL(string: patient.image))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    //.overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    //.cornerRadius(16.0)
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text(patient.firstName + " " + patient.lastName)
                        .font(.title2)
                        .bold()
                    
                    HStack{
                        Text("Grupo: " + patient.group)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Nivel Cognitivo: " + patient.cognitiveLevel)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(patient.communicationStyle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    print("Comunicador")
                }) {
                    Text("Comunicador")
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        //.background(Color(.systemGray6))
        //.cornerRadius(10)
        //.shadow(radius: 5)
        .padding(.vertical, 5)
    }
}

/*
struct AdminView: View {
    
    @StateObject var patients = PatientsViewModel()
    
    @State var searchText = ""
    @State var isSearching = false
    @State private var showAddPatient = false

    
    var body: some View {
        NavigationView{
            ScrollView{
                
                //Filtros y añadir niños
                HStack{
                    //Barra de busqueda
                    SearchBar(searchText: $searchText, isSearching: $isSearching)
                    Button{
                        showAddPatient = true
                    } label : {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showAddPatient){
                        AddPatientView(patients: patients)
                    }
                    
                }

                //Tarjetas niños
                LazyVGrid(columns: [GridItem(.flexible(minimum: 500, maximum: 900), spacing: 10, alignment: .top)], spacing: 12) {
                    ForEach((patients.patientsList).filter({"\($0)".contains(searchText) || searchText.isEmpty}), id: \.self){ patient in
                        
                        PatientCard(patient: patient)
                        Divider()
                            .background(Color(.systemGray2))
                            .padding(.leading)
                    }
                }.padding(.horizontal, 12)
            }
            .navigationTitle("Buscar")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
*/
/*
struct PatientCard: View {
    
    let patient: Patient
    
    var body: some View{
        HStack {
            
            HStack{
                // Spacer()
                  //   .frame(width: 50, height: 50)
                    // .background(Color.blue)
                 KFImage(URL(string: patient.image))
                     .resizable()
                     .frame(width: 100, height: 100)
                     .scaledToFill()
                     .cornerRadius(15)
                     .padding()
                
                VStack{
                    
                    HStack{
                        Text(patient.firstName)
                            .font(.system(size:24))
                        Text(patient.lastName)
                            .font(.system(size:24))
                        Spacer()
                    }
                    
                    HStack{
                        Text("Grupo \(patient.group)")
                            .font(.system(size:15))
                        Text("Nivel Cognitivo \(patient.cognitiveLevel)")
                            .font(.system(size:15))
                        Text("\(patient.communicationStyle)")
                            .font(.system(size:15))
                        Spacer()
                    }
                    .foregroundColor(Color.gray)

                     
                }
            }.padding()
            
            HStack(alignment: .center){
                
                Button("Comunicador"){
                    print("Comunicador")
                }
                
            }.padding()

            

        }
        //.padding()
        .foregroundColor(.black)
        //.border(Color.black.opacity(0.1))
        //.shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        .cornerRadius(15)
    }
}
*/




struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}


struct SearchBar: View{
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack{
            HStack{
                TextField("Buscar niño", text: $searchText)
                    .padding(.leading, 24)
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(6)
            .padding(.horizontal)
            .onTapGesture {
                isSearching = true
            }
            .overlay(
                HStack{
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    
                    if(isSearching){
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.vertical)
                        }

                    }
                }.padding(.horizontal, 32)
                    .foregroundColor(.gray)
                    .transition(.move(edge: .trailing))
                    .animation(.spring())
            )
            
            if isSearching {
                Button(action: {
                    isSearching = false
                    searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Text("Cancel")
                        .padding(.trailing)
                    .padding(.leading, 0)
                    
                })
            }
        }
    }
}
