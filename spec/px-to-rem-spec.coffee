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

  it "converts with space and semicolon", ->
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
      expect(editor.getText()).toEqual("1.59375 rem;")

  it "select all the text from a file and converts all the ocurrences", ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText("""
    hello


    something

    15px


    0.5666666 2344555.56px 4 6rem


    again 1 0.2 14px 15px; yolo px 17px
    18px;
    19 px
    20px
    3333 px ;

    numbers

    23PX

    here""")
    editor.selectAll()
    changeHandler = jasmine.createSpy('changeHandler')
    editor.onDidChange(changeHandler)

    atom.commands.dispatch workspaceElement, 'px-to-rem:convert'

    waitsForPromise ->
      activationPromise

    waitsFor "change event", ->
      changeHandler.callCount > 0

    runs ->
      expect(editor.getText()).toEqual("""
      hello


      something

      0.9375rem


      0.5666666 146534.7225rem 4 6rem


      again 1 0.2 0.875rem 0.9375rem; yolo px 1.0625rem
      1.125rem;
      1.1875 rem
      1.25rem
      208.3125 rem ;

      numbers

      1.4375REM

      here""")

  it "converts in a css-like file", ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText("""
    h1 {
        font-size: 40px;
    }

    h2 {
        font-size: 30px;
    }

    p {
        font-size: 14px;
    }""")
    editor.selectAll()
    changeHandler = jasmine.createSpy('changeHandler')
    editor.onDidChange(changeHandler)

    atom.commands.dispatch workspaceElement, 'px-to-rem:convert'

    waitsForPromise ->
      activationPromise

    waitsFor "change event", ->
      changeHandler.callCount > 0

    runs ->
      expect(editor.getText()).toEqual("""
      h1 {
          font-size: 2.5rem;
      }

      h2 {
          font-size: 1.875rem;
      }

      p {
          font-size: 0.875rem;
      }""")
