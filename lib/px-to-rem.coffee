pxPattern = /// ^ # begin of line
    (\s*)         # zero or more spaces
    (\d+(.\d+)?)  # one or more numbers
    (\s*)         # zero or more spaces
    (px)          # followed by px letters
    (\s*)         # zero or more spaces
    (;*)          # for cases that the user select within
    $ ///i        # end of line and ignore cases

module.exports = PxToRem =
    config:
        baseSize:
            title: 'Default Base Size'
            description: 'This will change the base size to convert px to rem.'
            type: 'integer'
            default: 16
            minimum: 1

    activate: ->
        atom.commands.add 'atom-workspace', "px-to-rem:convert", => @convert()

    convert: ->
        editor = atom.workspace.getActiveTextEditor()
        buffer = editor.getBuffer()
        selections = editor.getSelections()

        # Group these actions so they can be undone together
        buffer.transact ->
          for selection in selections

            original = text = selection.getText()
            if text.match pxPattern
                text = text.replace /\s+/g, ""
                num = parseFloat(text)/atom.config.get('px-to-rem.baseSize')
                semicolon = text.slice(-1)
                if semicolon.match ";"
                    selection.insertText(num + "rem;")
                else
                    selection.insertText(num + "rem")
            else
                selection.insertText(original)
