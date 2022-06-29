angular.module('doubtfire.units.states.edit.directives.unit-details-editor', [])

#
# Editor for the basic details of a unit, such as the name, code
# start and end dates etc.
#
.directive('unitDetailsEditor', ->
  replace: true
  restrict: 'E'
  templateUrl: 'units/states/edit/directives/unit-details-editor/unit-details-editor.tpl.html'
  controller: ($scope, $state, $rootScope, DoubtfireConstants, newUnitService, alertService, TeachingPeriod, TaskSubmission) ->
    $scope.overseerEnabled = DoubtfireConstants.IsOverseerEnabled

    $scope.calOptions = {
      startOpened: false
      endOpened: false
    }

    # Get docker images available for automated task assessment for the unit.
    TaskSubmission.getDockerImagesAsPromise().then (images) ->
      $scope.dockerImages = images

    # Get the confugurable, external name of Doubtfire
    $scope.externalName = DoubtfireConstants.ExternalName

    # get the teaching periods- gets an object with the loaded teaching periods
    $scope.teachingPeriods = TeachingPeriod.query()

    # Datepicker opener
    $scope.open = ($event, pickerData) ->
      $event.preventDefault()
      $event.stopPropagation()

      if pickerData == 'start'
        $scope.calOptions.startOpened = ! $scope.calOptions.startOpened
        $scope.calOptions.endOpened = false
      else
        $scope.calOptions.startOpened = false
        $scope.calOptions.endOpened = ! $scope.calOptions.endOpened

    $scope.dateOptions = {
      formatYear: 'yy',
      startingDay: 1
    }
    $scope.studentSearch = ""

    $scope.saveUnit = ->
      newUnitService.update($scope.unit).subscribe({
        next: (unit) ->
          alertService.add("success", "Unit updated.", 2000)
        error: (response) ->
          alertService.add("danger", "Failed to update unit. #{response}", 6000)
    })

)




