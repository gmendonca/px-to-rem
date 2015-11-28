postcss = require 'postcss'
pxtorem = require 'postcss-pxtorem'

module.exports = PxToRem =

  config:
    baseSize:
      title: 'Default Base Size'
      description: 'This will change the base size to convert px to rem.'
      type: 'integer'
      default: 16
      minimum: 1

  activate: ->
    atom.commands.add 'atom-workspace', 'px-to-rem:convert', => @convert()

  convert: ->
    editor = atom.workspace.getActiveTextEditor()
    buffer = editor.getBuffer()
    selections = editor.getSelections()

    # Group these actions so they can be undone together
    buffer.transact ->
      for selection in selections

        css = selection.getText()
        options = {
          root_value: atom.config.get 'px-to-rem.baseSize'
        }

        # Process valid CSS
        try
          processedCss = postcss(pxtorem(options)).process(css).css
          selection.insertText(processedCss)

        catch error

          # Process standalone values
          try
            # This is a weird hack. The PostCSS library doesn't work unless
            # the selection is valid CSS. But we still want selections like
            # "20px" to work properly, so it gets faked.
            css = 'font-size:' + css + ';'
            processedCss = postcss(pxtorem(options)).process(css).css
            processedCss = processedCss.substring(10, processedCss.length-1)
            selection.insertText(processedCss)
          catch error
            atom.notifications.addWarning "The selection was not valid CSS."
