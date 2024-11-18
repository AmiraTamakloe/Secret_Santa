//
//  ParticipantManager.swift
//  Secret Santa
//
//  Created by Amira Tamakloe on 2024-11-17.
//

import Foundation

class ParticipantManager: ObservableObject {
    @Published var participants: [Participant] = []
    
    func addParticipant(name: String, email: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedName.isEmpty && !trimmedEmail.isEmpty {
            let newEntry = Participant(name: trimmedName, email: trimmedEmail)
            participants.append(newEntry)
        }
    }
    
    func clearParticipants() {
        participants = []
    }
}

struct Participant: Identifiable {
    let id = UUID()
    let name: String
    let email: String
}
