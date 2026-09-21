import QtQuick
import QtQuick.Shapes
import qs.components
import qs.services

// The card's own little robot: a domed head with two antennae and a visor cut
// clean out of it. Drawn rather than pulled from the icon font so the visor is
// a real hole — it takes the card's colour through it, the way the usage blobs
// sit on the surface rather than over it.
Item {
    id: root

    property color colour: Colours.palette.m3primary

    implicitWidth: 22
    implicitHeight: 22

    Shape {
        anchors.centerIn: parent

        width: 24
        height: 24
        scale: Math.min(root.width / width, root.height / height)
        transformOrigin: Item.Center

        preferredRendererType: Shape.CurveRenderer
        asynchronous: true

        // Antennae first, so the head paints over the ends buried in the dome
        ShapePath {
            fillColor: root.colour
            strokeColor: "transparent"

            PathSvg {
                path: "M 3.95 8.5 L 3.95 1.95 A 0.55 0.55 0 0 1 5.05 1.95 L 5.05 8.5 Z M 18.95 8.5 L 18.95 1.95 A 0.55 0.55 0 0 1 20.05 1.95 L 20.05 8.5 Z"
            }
        }

        // Head, visor, eyes — nested, so odd-even alternates hole and fill by
        // itself: inside the head fills, inside the visor cuts, inside an eye
        // fills again
        ShapePath {
            fillRule: ShapePath.OddEvenFill
            fillColor: root.colour
            strokeColor: "transparent"

            PathSvg {
                path: "M 2.6 11 A 9.4 6.5 0 0 1 21.4 11 L 21.4 16 A 5 5 0 0 1 16.4 21 L 7.6 21 A 5 5 0 0 1 2.6 16 Z M 9.2 10 L 14.8 10 A 3.5 3.5 0 0 1 14.8 17 L 9.2 17 A 3.5 3.5 0 0 1 9.2 10 Z M 7.85 13.5 A 1.45 1.45 0 1 1 10.75 13.5 A 1.45 1.45 0 1 1 7.85 13.5 Z M 13.25 13.5 A 1.45 1.45 0 1 1 16.15 13.5 A 1.45 1.45 0 1 1 13.25 13.5 Z"
            }
        }
    }

    Behavior on colour {
        CAnim {}
    }
}
