//
//  LeafFeature.swift
//  BrokenDismiss
//
//  Created by Oliver Foggin on 29/11/2023.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct LeafFeature {
	struct State {
		var text: String = "Hello"
	}

	enum Action {
		case printButtonTapped
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .printButtonTapped:
				print(state.text)
				return .none
			}
		}
	}
}

struct LeafView: View {
	let store: StoreOf<LeafFeature>

	var body: some View {
		WithViewStore(store, observe: \.text) { viewStore in
			Text(viewStore.state)

			Button {
				viewStore.send(.printButtonTapped)
			} label: {
				Text("Print message")
			}
		}
	}
}
