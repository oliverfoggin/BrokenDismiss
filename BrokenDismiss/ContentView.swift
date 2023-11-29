//
//  ContentView.swift
//  BrokenDismiss
//
//  Created by Oliver Foggin on 29/11/2023.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AppFeature {
	struct State {
		@CasePathable @dynamicMemberLookup enum Destination {
			case sheet(SheetFeature.State)
		}

		@PresentationState var destination: Destination?
	}

	enum Action {
		case destination(PresentationAction<Destination>)

		case sheetButtonTapped

		@CasePathable enum Destination {
			case sheet(SheetFeature.Action)
		}
	}

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .sheetButtonTapped:
				state.destination = .sheet(.init())
				return .none

			case .destination:
				return .none
			}
		}
		.ifLet(\.$destination, action: \.destination) {
			Scope(state: \.sheet, action: \.sheet) { SheetFeature() }
		}
	}
}

struct ContentView: View {
	let store: StoreOf<AppFeature>

	var body: some View {
		VStack {
			Button {
				store.send(.sheetButtonTapped)
			} label: {
				Text("Show sheet")
			}
		}
		.fullScreenCover(store: store.scope(state: \.$destination.sheet, action: \.destination.sheet), content: SheetView.init)
		.padding()
	}
}

#Preview {
	ContentView(store: .init(initialState: .init(), reducer: AppFeature.init))
}
