//
//  ContentView.swift
//  Secret Santa
//
//  Created by Amira Tamakloe on 2024-11-17.
//

import SwiftUI
import MessageUI

struct ContentView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @StateObject private var participantManager = ParticipantManager()
    @StateObject private var secretSantaGenerator = SecretSantaGenerator()
    
    @State private var mailData: MailData? = nil
    @State private var showMailView = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    
    var body: some View {
        VStack {
            
            TextField("Enter your name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

            TextField("Enter your email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .keyboardType(.emailAddress)
            
            Button(action: addParticipant) {
                                Text("Add")
                            }
            
            Text("Participants:").font(.headline).padding(.top)
            List(participantManager.participants) { participant in
                            VStack(alignment: .leading) {
                                Text("Name: \(participant.name)")
                                Text("Email: \(participant.email)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
            
            Button(action: generateMatch) {
                            Text("Generate Your Match")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal).disabled(participantManager.participants.count <= 1)
        }
        .padding()
        .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Secret Santa Matches"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
        }
        .sheet(isPresented: $showMailView) {
                    if let mailData = mailData {
                        MailView(data: mailData)
                    }
                }
    }
    
    private func addParticipant() {
        participantManager.addParticipant(name: name, email: email)
        clearFields()
    }

    private func clearFields() {
        name = ""
        email = ""
    }
    
    private func clearParticipants() {
            participantManager.clearParticipants()
    }
    
    private func generateMatch() {
        guard participantManager.participants.count > 1 else {
            alertMessage = "Add at least two participants to generate matches."
            showAlert = true
            return
        }
        
        guard let matches = secretSantaGenerator.matchParticipants(participants: participantManager.participants) else {
            alertMessage = "No valid matches found."
            showAlert = true
            clearFields()
            return
        }

        secretSantaGenerator.sendEmail(matches: matches) { mailComposer in
            mailData = MailData(controller: mailComposer)
            showMailView = true
            alertMessage = formatMatchAlert(matches: matches, emailSent: true)
            showAlert = true
            clearFields()
            clearParticipants()
        } errorHandler: {
            // Trigger alert for failed email sending
            alertMessage = formatMatchAlert(matches: matches, emailSent: false)
            clearParticipants()
            showAlert = true
        }
    }
    
    private func formatMatchAlert(matches: [(giver: Participant, receiver: Participant)], emailSent: Bool) -> String {
        var message = matches.map { "\($0.giver.name) → \($0.receiver.name)" }.joined(separator: "\n")
        message += "\n\n"
        message += emailSent ? "Emails were successfully sent." : "Emails could not be sent, but these were the matches."
        return message
    }


}

#Preview {
    ContentView()
}


