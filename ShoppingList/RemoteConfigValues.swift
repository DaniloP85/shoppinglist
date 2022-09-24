//
//  RemoteConfigValues.swift
//  ShoppingList
//
//  Created by pos on 22/09/22.
//  Copyright © 2022 FIAP. All rights reserved.
//

import Foundation
import Firebase

class RemoteConfigValues {
    
    static let shared = RemoteConfigValues()
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    var copyrightMessage: String {
        remoteConfig.configValue(forKey: "copyrightMessage").stringValue ?? "Não tinha nada"
    }
    var showCreateAccount: Bool {
        remoteConfig.configValue(forKey: "showCreateAccount").boolValue
    }
    
    private init() {
        loadDefaultValues()
    }
    
    private func loadDefaultValues() {
        let defaultValues: [String: Any] = [
            "copyrightMessage": "Copyright 2022 - FIAP",
            "showCreateAccount": true
        ]
        remoteConfig.setDefaults(defaultValues as? [String: NSObject])
    }
    
    func fetch() {
        remoteConfig.fetch(withExpirationDuration: 1.0) { status, error in
            if let error = error {
                print("Erro ao fazer o fetch:", error.localizedDescription)
            } else {
                switch status {
                case .failure:
                    print("Erro no fetch")
                case .noFetchYet:
                    print("Não fez o fetch")
                case .throttled:
                    print("Espera os 12 min zé ruela")
                case .success:
                    print("Agora deve ir!!!")
                    self.remoteConfig.activate()
                default:
                    print("Desconhecido!!")
                }
                
            }
        }
    }
    
}
