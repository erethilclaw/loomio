angular.module('loomioApp').directive 'proposalAccordian', ->
  scope: {model: '=', selectedProposalId: '=?', pageSize: '@'}
  restrict: 'E'
  templateUrl: 'generated/components/proposal_accordian/proposal_accordian.html'
  replace: true
  controller: ($scope, Records, AppConfig, LoadingService) ->
    from = 0
    pageSize = $scope.pageSize || AppConfig.pageSize.proposalAccordian || AppConfig.pageSize.default

    $scope.loadMore = ->
      loadedFn = (response) ->
        from += pageSize
        $scope.hasMoreProposals = response.proposals.length == pageSize

      method = switch $scope.model.constructor.singular
        when 'discussion' then 'fetchByDiscussion'
        when 'group'      then 'fetchClosedByGroup'

      Records.proposals[method]($scope.model.key, from: from, per: pageSize).then(loadedFn)
    $scope.loadMore()
    LoadingService.applyLoadingFunction $scope, 'loadMore'

    $scope.$on 'collapseProposal', (event) ->
      $scope.selectedProposalId = null

    $scope.selectProposal = (proposal) =>
      $scope.selectedProposalId = proposal.id
