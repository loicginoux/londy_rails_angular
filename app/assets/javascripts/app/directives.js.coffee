window.londy.directive "focusMe", ($timeout, $parse) ->  
  #scope: true,   // optionally create a child scope
  link: (scope, element, attrs) ->
    model = $parse(attrs.focusMe)
    scope.$watch model, (value) ->
      #console.log "value=", value
      if value is true
        $timeout ->
          element[0].focus()

    # element.bind "blur", ->
    #   #console.log "blur"
    #   scope.$apply model.assign(scope, false)

window.londy.directive "blurMe", ($timeout, $parse) ->  
  #scope: true,   // optionally create a child scope
  link: (scope, element, attrs) ->
    model = $parse(attrs.focusMe)
    scope.$watch model, (value) ->
      #console.log "value=", value
      if value is true
        $timeout ->
          element[0].blur()

window.londy.directive "ngEscape", ->
  (scope, element, attrs) ->
    element.bind "keydown keypress", (event) ->
      if event.which is 27
        scope.$apply ->
          scope.$eval attrs.ngEnter
        event.preventDefault()


