import QtQuick
import qs.Commons

// 16x16 pixel monkey. mood: idle | think
Item {
  id: root

  property string mood: "idle"
  property color fur: "#9a7a3c"
  property color face: "#d4b07a"
  property color eye: "#1c1810"
  property color mouth: "#5a3020"
  property color accent: Color.accent

  readonly property int px: Math.max(1, Math.floor(Math.min(width, height) / 16))
  readonly property int art: px * 16

  property int frame: 0

  readonly property var idleFrames: [
    [
      "................",
      "....kkkkkk......",
      "...kffffffk.....",
      "..kffffffffk....",
      "..kffllllffk....",
      ".kffllllllffk...",
      ".kfllsseellfk...",
      ".kflsssssslfk...",
      "..klssmmsslk....",
      "..kksssssskk....",
      "...kffffffk.....",
      "..kkffffffkk....",
      ".kffkkkkkkffk...",
      ".kfk......kfk...",
      "..k........k....",
      "................"
    ],
    [
      "................",
      "....kkkkkk......",
      "...kffffffk.....",
      "..kffffffffk....",
      "..kffllllffk....",
      ".kffllllllffk...",
      ".kfllssssllfk...",
      ".kflsssssslfk...",
      "..klssmmsslk....",
      "..kksssssskk....",
      "...kffffffk.....",
      "..kkffffffkk....",
      ".kffkkkkkkffk...",
      ".kfk......kfk...",
      "..k........k....",
      "................"
    ]
  ]

  readonly property var thinkFrames: [
    [
      "................",
      "....kkkkkk......",
      "...kffffffk.....",
      "..kffffffffk....",
      "..kffllllffk....",
      ".kffllllllffk...",
      ".kfllssaallfk...",
      ".kflsssssslfk...",
      "..klssmmsslk....",
      "..kksssssskk....",
      "...kffffffk.....",
      "..kkffffffkk....",
      ".kffkkkkkkffk...",
      ".kfk....a.kfk...",
      "..k........k....",
      "................"
    ],
    [
      "................",
      ".....kkkkkk.....",
      "....kffffffk....",
      "...kffffffffk...",
      "...kffllllffk...",
      "..kffllllllffk..",
      "..kfllaassaalfk.",
      "..kflsssssslfk..",
      "...klssmmsslk...",
      "...kksssssskk...",
      "....kffffffk....",
      "...kkffffffkk...",
      "..kffkkkkkkffk..",
      "..kfk...a..kfk..",
      "...k........k...",
      "................"
    ]
  ]

  function cellColor(ch) {
    if (ch === "k") return Qt.darker(root.fur, 2.6)
    if (ch === "f") return root.fur
    if (ch === "l") return Qt.lighter(root.fur, 1.28)
    if (ch === "s") return root.face
    if (ch === "e") return root.eye
    if (ch === "m") return root.mouth
    if (ch === "a") return root.accent
    return "transparent"
  }

  readonly property var rows: {
    var bank = root.mood === "think" ? root.thinkFrames : root.idleFrames
    return bank[root.frame % bank.length]
  }

  implicitWidth: art
  implicitHeight: art

  Timer {
    interval: root.mood === "think" ? 180 : 700
    running: true
    repeat: true
    onTriggered: {
      if (root.mood === "think") {
        root.frame = (root.frame + 1) % 2
        return
      }
      // mostly eyes open, rare blink
      root.frame = root.frame === 0 ? (Math.random() < 0.18 ? 1 : 0) : 0
    }
  }

  Column {
    anchors.centerIn: parent
    width: root.art
    height: root.art
    spacing: 0

    Repeater {
      model: 16
      Row {
        required property int index
        spacing: 0
        Repeater {
          model: 16
          Rectangle {
            required property int index
            width: root.px
            height: root.px
            color: root.cellColor(root.rows[parent.index].charAt(index))
          }
        }
      }
    }
  }
}
