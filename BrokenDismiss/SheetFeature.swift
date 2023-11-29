//
//  SheetFeature.swift
//  BrokenDismiss
//
//  Created by Oliver Foggin on 29/11/2023.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SheetFeature {
	struct State {
		@CasePathable @dynamicMemberLookup enum Destination {
			case leaf(LeafFeature.State)
		}

		@PresentationState var destination: Destination?
	}
	
	enum Action {
		case destination(PresentationAction<Destination>)

		case pushButtonTapped
		case closeButtonTapped

		@CasePathable enum Destination {
			case leaf(LeafFeature.Action)
		}
	}

	@Dependency(\.dismiss) var dismiss

	var body: some ReducerOf<Self> {
		Reduce<State, Action> { state, action in
			switch action {
			case .destination:
				return .none
			case .pushButtonTapped:
				state.destination = .leaf(.init())
				return .none
			case .closeButtonTapped:
				return .run { _ in
					 await dismiss()
				}
			}
		}
	}
}

struct SheetView: View {
	let store: StoreOf<SheetFeature>

	var body: some View {
		NavigationStack {
			VStack {
				Button {
					store.send(.pushButtonTapped)
				} label: {
					Text("Push leaf feature")
				}
			}
			.navigationDestination(store: store.scope(state: \.$destination.leaf, action: \.destination.leaf), destination: LeafView.init)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button {
						store.send(.closeButtonTapped)
					} label: {
						Text("Close")
					}
				}
			}
		}
	}
}
