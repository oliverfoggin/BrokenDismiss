//
//  BrokenDismissApp.swift
//  BrokenDismiss
//
//  Created by Oliver Foggin on 29/11/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct BrokenDismissApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView(store: .init(initialState: .init()) { AppFeature()._printChanges() })
		}
	}
}
