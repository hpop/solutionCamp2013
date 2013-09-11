'use strict';

angular.module('SolutionCampApp')
  .directive('slpnSlideshow', ($timeout, $compile) ->
    template: """
              <div class='slideshow'></div>
              """
    restrict: 'E'
    replace:true
    transclude: true
    scope: false
    compile: (elem, attrs, transclude) ->

      return (scope, element, attrs) ->
          scope.currentSlide = 0
          scope.slides = 0

          scope.keyDown = (e) ->
            switch e.keyCode
              when 39 then next()
              when 37 then prev()
            return

          next = ->
            return if scope.currentSlide >= scope.slides - 1
            scope.currentSlide++

          prev = ->
            return if scope.currentSlide <= 0
            scope.currentSlide--

          angular.element(window).bind 'keyup', (e) ->
            scope.$apply ->
              scope.keyDown(e)

          transclude scope, (clone, innerScope) ->
            i = 0
            for child in clone
              continue if child.nodeType != 1
              wrapper1 = angular.element("<div class='slide' ng-class='{active: currentSlide == #{i}}'></div>")
              wrapper2 = angular.element("<div class='centered'></div>")
              wrapper2.append(child)
              wrapper1.append(wrapper2)
              elem.append($compile(wrapper1)(innerScope))
              i++

            scope.slides = i

          $timeout ->
            for element in element.find('code')
              hljs.highlightBlock(element)
              $('body').swipe {
                swipeLeft: ->
                  scope.$apply ->
                    next()
                swipeRight: ->
                  scope.$apply ->
                    prev()
              }

  )
