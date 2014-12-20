pxPattern = /// ^ # begin of line
    (\s*)         # zero or more spaces
    ([0-9]+)      # one or more numbers
    (\s*)         # zero or more spaces
    (px)          # followed by px letters
    (\s*)         # zero or more spaces
    (;*)          # for cases that the user select within
    $ ///i        # end of line and ignore cases

module.exports = PxToRem =
    activate: ->
        atom.workspaceView.command "px-to-rem:convert", => @convert()

    convert: ->
        editor = atom.workspace.activePaneItem
        selection = editor.getSelection()
        original = text = selection.getText()
        if text.match pxPattern
            text = text.replace /\s+/g, ""
            num = parseInt(text, 10)/16
            semicolon = text.slice(-1)
            if semicolon.match ";"
                selection.insertText(num + "rem;")
            else
                selection.insertText(num + "rem")
        else
            selection.insertText(original)
