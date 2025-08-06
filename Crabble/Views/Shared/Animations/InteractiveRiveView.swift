import RiveRuntime
import SwiftUI

// Interactive Rive view with state machine control
struct InteractiveRiveView: UIViewRepresentable {
    let resourceName: String
    let stateMachineName: String?
    @Binding var triggerBubble: Bool

    private let viewModel: RiveViewModel

    init(resourceName: String, stateMachineName: String? = nil, triggerBubble: Binding<Bool>) {
        self.resourceName = resourceName
        self.stateMachineName = stateMachineName
        _triggerBubble = triggerBubble
        viewModel = RiveViewModel(fileName: resourceName, extension: "riv", stateMachineName: stateMachineName)
    }

    func makeUIView(context _: Context) -> RiveView {
        let riveView = viewModel.createRiveView()
        riveView.backgroundColor = UIColor.clear
        riveView.isOpaque = false
        riveView.layer.backgroundColor = UIColor.clear.cgColor
        riveView.clipsToBounds = false
        return riveView
    }

    func updateUIView(_: RiveView, context _: Context) {
        // Fire the bubble trigger when triggerBubble changes to true
        if triggerBubble {
            viewModel.triggerInput("bubble")
            DispatchQueue.main.async {
                triggerBubble = false // Reset the trigger
            }
        }
    }
}

// Alternative approach with direct trigger method
struct DirectTriggerRiveView: UIViewRepresentable {
    let resourceName: String
    let stateMachineName: String?
    private let viewModel: RiveViewModel

    init(resourceName: String, stateMachineName: String? = nil) {
        self.resourceName = resourceName
        self.stateMachineName = stateMachineName
        viewModel = RiveViewModel(fileName: resourceName, extension: "riv", stateMachineName: stateMachineName)
    }

    func makeUIView(context _: Context) -> RiveView {
        let riveView = viewModel.createRiveView()
        riveView.backgroundColor = UIColor.clear
        riveView.isOpaque = false
        riveView.layer.backgroundColor = UIColor.clear.cgColor
        riveView.clipsToBounds = false
        return riveView
    }

    func updateUIView(_: RiveView, context _: Context) {}

    // Method to trigger the bubble animation
    func triggerBubble() {
        viewModel.triggerInput("bubble")
    }
}

struct InteractiveRiveContainer: View {
    @State private var shouldTriggerBubble = false

    var body: some View {
        VStack(spacing: 20) {
            InteractiveRiveView(
                resourceName: "crabble-light",
                stateMachineName: nil,
                triggerBubble: $shouldTriggerBubble
            )
            .frame(height: 200)
            .background(Color.clear)
            .onTapGesture {
                shouldTriggerBubble = true
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

struct InteractiveRiveContainer_Previews: PreviewProvider {
    static var previews: some View {
        InteractiveRiveContainer()
    }
}
