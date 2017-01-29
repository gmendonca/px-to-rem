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
            title: 'Default base value'
            description: 'This will change the base value when converting px to rem.'
            type: 'integer'
            default: 16
            minimum: 1
        precision:
            title: 'Number of decimal places'
            description: 'The desired number of decimal places when converting. The default value 0 will let the editor handle the number of decimal places.'
            type: 'integer'
            default: 0
            minimum: 0

    activate: ->
        atom.commands.add 'atom-workspace', "px-to-rem:convert", => @convert()

    convert: ->
        editor = atom.workspace.getActiveTextEditor()
        buffer = editor.getBuffer()
        selections = editor.getSelections()

        # Group these actions so they can be undone together
        buffer.transact ->
          for selection in selections
            original = selection.getText()
            matches = original.match(pxPattern)
            for i of matches
              text = matches[i].replace(/\s+/g, "")
              num = parseFloat(text.slice(0,-2))/atom.config.get('px-to-rem.baseSize')
              precision = atom.config.get('px-to-rem.precision')
              if precision > 0
                precision = Math.pow(10, precision)
                num = Math.round(num * precision) / precision
              toReplace = matches[i]
                            .replace(matches[i].match(numbersPattern), num)
                            .replace("px", "rem").replace("PX", "REM")
              original = original.replace(matches[i], toReplace)
            selection.insertText(original)
