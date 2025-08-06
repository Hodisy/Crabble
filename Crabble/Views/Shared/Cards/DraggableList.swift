import SwiftUI

struct Item: Identifiable, Equatable {
    let id = UUID()
    var text: String
}

struct DraggableList: View {
    @Binding var items: [Item]
    @State private var draggedItem: Item?
    @State private var dragOffset: CGSize = .zero

    init(items: Binding<[Item]>) {
        _items = items
    }

    init() {
        _items = .constant([
            Item(text: "Open your FAFSA email"),
            Item(text: "Check missing documents"),
            Item(text: "Take a picture of your income"),
            Item(text: "Upload the document"),
        ])
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                ItemRowView(
                    itemNumber: index + 1,
                    itemText: item.text,
                    onDelete: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            items.removeAll { $0.id == item.id }
                        }
                    }
                )
                .padding(.bottom, index < items.count - 1 ? 12 : 0)
                .scaleEffect(draggedItem?.id == item.id ? 1.05 : 1.0)
                .opacity(draggedItem?.id == item.id ? 0.8 : 1.0)
                .offset(draggedItem?.id == item.id ? dragOffset : .zero)
                .zIndex(draggedItem?.id == item.id ? 1 : 0)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if draggedItem == nil {
                                draggedItem = item
                            }
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            let dropIndex = calculateDropIndex(for: value.location, currentIndex: index)
                            moveItem(from: index, to: dropIndex)

                            withAnimation(.easeInOut(duration: 0.3)) {
                                draggedItem = nil
                                dragOffset = .zero
                            }
                        }
                )
            }
        }
        .frame(width: 352)
    }

    private func calculateDropIndex(for location: CGPoint, currentIndex _: Int) -> Int {
        let itemHeight: CGFloat = 82 // 70px height + 12px spacing
        let dropIndex = max(0, min(items.count - 1, Int(location.y / itemHeight)))
        return dropIndex
    }

    private func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }

        withAnimation(.easeInOut(duration: 0.3)) {
            let item = items.remove(at: sourceIndex)
            items.insert(item, at: destinationIndex)
        }
    }
}

struct ItemRowView: View {
    let itemNumber: Int
    let itemText: String
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Cercle avec numéro à gauche
            ZStack {
                Circle()
                    .fill(Color(hex: "F3F4F6"))
                    .frame(width: 24, height: 24)

                Text("\(itemNumber)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "4B5563"))
            }

            // Texte de l'item
            Text(itemText)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: "1F2937"))
                .frame(maxWidth: .infinity, alignment: .leading)

            // Bouton croix à droite
            Button(action: onDelete) {
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 36, height: 36)

                    Image("CloseIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(hex: "9CA3AF"))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 16)
        .frame(height: 70)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

// Vue principale pour la démonstration
struct DraggableListPreview: View {
    var body: some View {
        VStack {
            Text("Liste d'éléments")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 24)

            DraggableList()

            Spacer()
        }
        .padding(.top, 32)
        .navigationBarHidden(true)
        .background(Color(hex: "FAFAFA"))
    }
}

struct DraggableList_Previews: PreviewProvider {
    static var previews: some View {
        DraggableListPreview()
    }
}
