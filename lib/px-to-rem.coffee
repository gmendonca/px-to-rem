pxPattern =
  ///
    (\s*)             # zero or more spaces
    (\d+(\.)*(\d+)?)  # integers or decimal numbers
    (\s*)             # zero or more spaces
    (px)              # followed by px letters
  ///ig               # ignore cases and global

numbersPattern = /(\d+(\.)*(\d+)?)/g

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
            console.log selection.isEmpty
            original = selection.getText()
            matches = original.match(pxPattern)
            for i of matches
              text = matches[i].replace(/\s+/g, "")
              num = parseFloat(text.slice(0,-2))/atom.config.get('px-to-rem.baseSize')
              toReplace = matches[i]
                            .replace(matches[i].match(numbersPattern), num)
                            .replace("px", "rem").replace("PX", "REM")
              original = original.replace(matches[i], toReplace)
            selection.insertText(original)
