# This routing directive tells Angular about the default
# route for our application. The term "otherwise" here
# might seem somewhat awkward, but it will make more
# sense as we add more routes to our application.
window.londy.config(['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when('/projects/:id', { controller: 'taskListCtrl'})
    .otherwise({redirectTo: '/'}) 
]).run(() -> console.log('only run on first page load'))


window.londy.config(['$httpProvider', ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
])

window.londy.config((RestangularProvider) ->
  RestangularProvider.setBaseUrl('/api')
  RestangularProvider.setErrorInterceptor((error) -> console.log(error))
)
