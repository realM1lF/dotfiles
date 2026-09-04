import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "rin.companion"
  ipcTarget: "rin.companion"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null
  property bool openedFromHotkey: false

  readonly property var barIdentity: hostWidget || root
  readonly property string dataDir: Color.home + "/.local/share/rin-companion"
  readonly property string pluginDir: Color.home + "/.config/omarchy/plugins/rin.companion"
  readonly property color fg: bar ? bar.foreground : Color.foreground
  readonly property color dim: Color.muted
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family

  property int tab: 0
  property string rulesDraft: ""
  property string soulDraft: ""
  property string userDraft: ""
  property string memoryText: ""
  property string rulesSaved: ""
  property string soulSaved: ""
  property string userSaved: ""
  property bool rulesDirtyHold: false
  property bool soulDirtyHold: false
  property bool userDirtyHold: false
  property var transcript: []
  property bool busy: false
  property string pendingUser: ""
  property string lastError: ""

  readonly property bool onChat: tab === 0
  readonly property bool canEdit: tab === 1 || tab === 2 || tab === 3
  readonly property bool dirty: tab === 1 ? rulesDraft !== rulesSaved : (tab === 2 ? soulDraft !== soulSaved : (tab === 3 ? userDraft !== userSaved : false))
  readonly property string tabName: tab === 1 ? "rules" : (tab === 2 ? "soul" : (tab === 3 ? "user" : (tab === 4 ? "memory" : "chat")))
  readonly property string monkeyMood: busy ? "think" : "idle"

  function open() {
    openedFromHotkey = false
    root.tab = 1
    setCenterHoverRevealSuppressed(false)
    reloadFiles()
    root.controller.show()
  }

  function openFromHotkey() {
    openedFromHotkey = true
    root.tab = 1
    reloadFiles()
    root.controller.show()
    Qt.callLater(function() {
      if (root.opened) setCenterHoverRevealSuppressed(true)
    })
  }

  function close() {
    setCenterHoverRevealSuppressed(false)
    root.controller.hide()
  }

  function toggle() {
    if (root.opened) root.close()
    else root.openFromHotkey()
  }

  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.barIdentity, direction)
    return false
  }

  function setCenterHoverRevealSuppressed(value) {
    if (root.bar && "centerHoverRevealSuppressed" in root.bar)
      root.bar.centerHoverRevealSuppressed = value
  }

  function reloadFiles() {
    rulesFile.reload()
    soulFile.reload()
    userFile.reload()
    memoryFile.reload()
    logFile.reload()
  }

  function applyEditor() {
    if (root.tab === 1) root.rulesDraft = editor.text
    else if (root.tab === 2) root.soulDraft = editor.text
    else if (root.tab === 3) root.userDraft = editor.text
  }

  function loadEditor() {
    if (root.tab === 1) editor.text = root.rulesDraft
    else if (root.tab === 2) editor.text = root.soulDraft
    else if (root.tab === 3) editor.text = root.userDraft
    else if (root.tab === 4) editor.text = root.memoryText
  }

  function setTab(index) {
    applyEditor()
    root.tab = index
    if (!root.onChat) loadEditor()
  }

  function save() {
    applyEditor()
    if (root.tab === 1) {
      rulesFile.setText(root.rulesDraft)
      root.rulesSaved = root.rulesDraft
      root.rulesDirtyHold = false
    } else if (root.tab === 2) {
      soulFile.setText(root.soulDraft)
      root.soulSaved = root.soulDraft
      root.soulDirtyHold = false
    } else if (root.tab === 3) {
      userFile.setText(root.userDraft)
      root.userSaved = root.userDraft
      root.userDirtyHold = false
    }
  }

  function persistLog() {
    logFile.setText(JSON.stringify(root.transcript, null, 2) + "\n")
  }

  function addTurn(role, text) {
    var next = root.transcript.slice()
    next.push({ role: role, text: text })
    root.transcript = next
    persistLog()
    Qt.callLater(scrollChatEnd)
  }

  function scrollChatEnd() {
    if (chatScroll.contentHeight > chatScroll.height)
      chatScroll.contentY = chatScroll.contentHeight - chatScroll.height
  }

  function sendChat() {
    var msg = String(chatInput.text || "").trim()
    if (msg === "" || root.busy) return
    chatInput.text = ""
    root.pendingUser = msg
    root.lastError = ""
    addTurn("rin", msg)
    promptFile.setText(msg)
    root.busy = true
    Qt.callLater(function() { chatProc.running = true })
  }

  function finishChat(ok, stdout, stderr) {
    root.busy = false
    var out = String(stdout || "").trim()
    var err = String(stderr || "").trim()
    if (ok && out !== "") {
      addTurn("affe", out)
      return
    }
    root.lastError = err !== "" ? err : "agent exit"
    addTurn("affe", root.lastError)
  }

  onOpenedChanged: if (opened) {
    reloadFiles()
    if (!root.onChat) Qt.callLater(loadEditor)
    Qt.callLater(scrollChatEnd)
  }

  FileView {
    id: rulesFile
    path: root.dataDir + "/rules.md"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: {
      root.rulesSaved = text()
      if (!root.rulesDirtyHold) root.rulesDraft = root.rulesSaved
      if (root.tab === 1) loadEditor()
    }
    onLoadFailed: {
      if (!root.rulesDirtyHold) {
        root.rulesSaved = ""
        root.rulesDraft = ""
        if (root.tab === 1) loadEditor()
      }
    }
  }

  FileView {
    id: soulFile
    path: root.dataDir + "/soul.md"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: {
      root.soulSaved = text()
      if (!root.soulDirtyHold) root.soulDraft = root.soulSaved
      if (root.tab === 2) loadEditor()
    }
    onLoadFailed: {
      if (!root.soulDirtyHold) {
        root.soulSaved = ""
        root.soulDraft = ""
        if (root.tab === 2) loadEditor()
      }
    }
  }

  FileView {
    id: userFile
    path: root.dataDir + "/user.md"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: {
      root.userSaved = text()
      if (!root.userDirtyHold) root.userDraft = root.userSaved
      if (root.tab === 3) loadEditor()
    }
    onLoadFailed: {
      if (!root.userDirtyHold) {
        root.userSaved = ""
        root.userDraft = ""
        if (root.tab === 3) loadEditor()
      }
    }
  }

  FileView {
    id: memoryFile
    path: root.dataDir + "/memory.md"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: {
      root.memoryText = text()
      if (root.tab === 4) loadEditor()
    }
    onLoadFailed: {
      root.memoryText = ""
      if (root.tab === 4) loadEditor()
    }
  }

  FileView {
    id: logFile
    path: root.dataDir + "/chat-log.json"
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoaded: {
      try {
        var parsed = JSON.parse(text())
        root.transcript = Array.isArray(parsed) ? parsed : []
      } catch (e) {
        root.transcript = []
      }
    }
    onLoadFailed: root.transcript = []
  }

  FileView {
    id: promptFile
    path: root.dataDir + "/pending-prompt.txt"
    printErrors: false
  }

  Process {
    id: chatProc
    command: ["bash", "-lc", "exec \"" + root.pluginDir + "/chat.sh\""]
    stdout: StdioCollector {
      id: chatOut
      waitForEnd: true
    }
    stderr: StdioCollector {
      id: chatErr
      waitForEnd: true
    }
    onExited: function(code) {
      root.finishChat(code === 0, chatOut.text, chatErr.text)
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.barIdentity
    bar: root.bar
    open: root.opened
    centerOnBar: true
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(620))
    contentHeight: panel.fittedContentHeight(Style.space(500))

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      blocked: editor.activeFocus || chatInput.activeFocus || root.busy
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Item {
        anchors.fill: parent

        Row {
          id: tabRow
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          spacing: Style.space(8)

          Button {
            text: "rules"
            selected: root.tab === 1
            foreground: root.fg
            accent: Color.accent
            onClicked: root.setTab(1)
          }
          Button {
            text: "soul"
            selected: root.tab === 2
            foreground: root.fg
            accent: Color.accent
            onClicked: root.setTab(2)
          }
          Button {
            text: "user"
            selected: root.tab === 3
            foreground: root.fg
            accent: Color.accent
            onClicked: root.setTab(3)
          }
          Button {
            text: "memory"
            selected: root.tab === 4
            foreground: root.fg
            accent: Color.accent
            onClicked: root.setTab(4)
          }
        }

        Item {
          id: chatPane
          visible: root.onChat
          anchors.top: tabRow.bottom
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.topMargin: Style.space(10)

          Row {
            id: hero
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Style.space(12)
            height: Style.space(72)

            Monkey {
              width: Style.space(64)
              height: Style.space(64)
              mood: root.monkeyMood
              accent: Color.accent
            }

            Column {
              anchors.verticalCenter: parent.verticalCenter
              spacing: Style.space(4)

              Text {
                textFormat: Text.PlainText
                text: root.busy ? "denkt …" : "haus-affe"
                color: root.fg
                font.family: root.fontFamily
                font.pixelSize: Style.font.body
                font.bold: true
              }
              Text {
                textFormat: Text.PlainText
                text: root.busy ? "agent --print, warte" : "tippen, Enter sendet"
                color: root.dim
                font.family: root.fontFamily
                font.pixelSize: Style.font.bodySmall
              }
            }
          }

          Flickable {
            id: chatScroll
            anchors.top: hero.bottom
            anchors.bottom: chatFoot.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Style.space(8)
            anchors.bottomMargin: Style.space(8)
            clip: true
            contentWidth: width
            contentHeight: chatCol.implicitHeight
            boundsBehavior: Flickable.StopAtBounds
            interactive: contentHeight > height

            Column {
              id: chatCol
              width: chatScroll.width
              spacing: Style.space(8)

              Repeater {
                model: root.transcript
                delegate: Text {
                  required property var modelData
                  width: chatCol.width
                  textFormat: Text.PlainText
                  wrapMode: Text.Wrap
                  color: modelData.role === "rin" ? root.fg : Color.accent
                  font.family: root.fontFamily
                  font.pixelSize: Style.font.body
                  text: (modelData.role === "rin" ? "rin: " : "affe: ") + modelData.text
                }
              }
            }
          }

          Row {
            id: chatFoot
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Style.space(8)

            TextField {
              id: chatInput
              width: parent.width - sendBtn.implicitWidth - parent.spacing
              foreground: root.fg
              accent: Color.accent
              enabled: !root.busy
              placeholderText: root.busy ? "warte …" : "Nachricht"
              onAccepted: root.sendChat()
            }

            Button {
              id: sendBtn
              text: root.busy ? "…" : "Senden"
              enabled: !root.busy
              foreground: root.fg
              accent: Color.accent
              onClicked: root.sendChat()
            }
          }
        }

        TextArea {
          id: editor
          visible: !root.onChat
          anchors.top: tabRow.bottom
          anchors.bottom: fileFoot.top
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.topMargin: Style.space(10)
          anchors.bottomMargin: Style.space(10)
          wrapMode: TextEdit.Wrap
          readOnly: root.tab === 4
          color: root.fg
          placeholderText: root.tab === 4 ? "Nur der Agent schreibt memory.md" : ""
          font.family: root.fontFamily
          font.pixelSize: Style.font.body
          selectByMouse: true
          onTextChanged: {
            if (root.tab === 1) {
              root.rulesDraft = text
              root.rulesDirtyHold = (text !== root.rulesSaved)
            } else if (root.tab === 2) {
              root.soulDraft = text
              root.soulDirtyHold = (text !== root.soulSaved)
            } else if (root.tab === 3) {
              root.userDraft = text
              root.userDirtyHold = (text !== root.userSaved)
            }
          }

          background: Rectangle {
            color: Qt.rgba(0, 0, 0, 0.18)
            border.width: 1
            border.color: editor.activeFocus ? Color.accent : Qt.darker(root.fg, 2.4)
            radius: Style.space(4)
          }
        }

        Row {
          id: fileFoot
          visible: !root.onChat
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          spacing: Style.space(10)

          Button {
            visible: root.canEdit
            enabled: root.dirty
            text: root.dirty ? "Speichern" : "Gespeichert"
            foreground: root.fg
            accent: Color.accent
            onClicked: root.save()
          }

          Text {
            textFormat: Text.PlainText
            text: root.canEdit ? (root.dirty ? tabName + ".md geändert" : tabName + ".md") : "memory.md nur lesen"
            color: root.dim
            font.family: root.fontFamily
            font.pixelSize: Style.font.bodySmall
            anchors.verticalCenter: parent.verticalCenter
          }
        }
      }
    }
  }
}
