//
//  MailView.swift
//  Secret Santa
//
//  Created by Amira Tamakloe on 2024-11-17.
//

import Foundation
import SwiftUI
import MessageUI

struct MailData {
    let controller: MFMailComposeViewController
}

struct MailView: UIViewControllerRepresentable {
    let data: MailData

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        data.controller
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    static func dismantleUIViewController(_ uiViewController: MFMailComposeViewController, coordinator: ()) {
        uiViewController.dismiss(animated: true)
    }
}
