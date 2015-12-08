PxToRem = require '../lib/px-to-rem'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "PxToRem", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('px-to-rem')
    waitsForPromise ->
        atom.workspace.open 'c.coffee'

  it "converts", ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText("25.5 px;")
    editor.selectAll()
    changeHandler = jasmine.createSpy('changeHandler')
    editor.onDidChange(changeHandler)

    atom.commands.dispatch workspaceElement, 'px-to-rem:convert'

    waitsForPromise ->
      activationPromise

    waitsFor "change event", ->
      changeHandler.callCount > 0

    runs ->
      expect(editor.getText()).toEqual("1.59375rem;")
