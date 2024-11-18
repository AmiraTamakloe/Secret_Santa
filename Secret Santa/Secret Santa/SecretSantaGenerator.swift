//
//  SecretSantaGenerator.swift
//  Secret Santa
//
//  Created by Amira Tamakloe on 2024-11-17.
//

import Foundation
import MessageUI



class SecretSantaGenerator: NSObject, ObservableObject, MFMailComposeViewControllerDelegate {
    
    func matchParticipants(participants: [Participant]) -> [(giver: Participant, receiver: Participant)]? {
        guard participants.count > 1 else {
            print("Not enough participants for matching.")
            return nil
        }
        
        let givers = participants
        var receivers = participants.shuffled()
        
        while !isValidMatching(givers: givers, receivers: receivers) {
            receivers.shuffle()
        }
        
        let matches = zip(givers, receivers).map { (giver, receiver) in
            (giver: giver, receiver: receiver)
        }
        
        print(matches)
        return matches
    }
    
    func isValidMatching(givers: [Participant], receivers: [Participant]) -> Bool {
        let forbiddenPairs: [(String, String)] = [
            ("Loic", "Lily"),
            ("Aurelie", "Vincent")
        ]
        
        for (giver, receiver) in zip(givers, receivers) {
            if giver.id == receiver.id {
                return false
            }
            
            if forbiddenPairs.contains(where: { $0.0 == giver.name && $0.1 == receiver.name }) {
                return false
            }
        }
        return true
    }
    
    func sendEmail(
        matches: [(giver: Participant, receiver: Participant)],
        mailComposerProvider: @escaping (MFMailComposeViewController) -> Void,
        errorHandler: (() -> Void)? = nil
    ) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail services are not available.")
            errorHandler?()
            return
        }

        for (giver, receiver) in matches {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self

            mailComposer.setToRecipients([giver.email])
            mailComposer.setSubject("Your Secret Santa Name!")
            mailComposer.setMessageBody(
                """
                Hi \(giver.name),
                
                You are the Secret Santa for \(receiver.name)!
                
                Good Luck Finding a gift!
                """,
                isHTML: false
            )

            mailComposerProvider(mailComposer)
        }
    }

    
    func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            controller.dismiss(animated: true)
        }
}
