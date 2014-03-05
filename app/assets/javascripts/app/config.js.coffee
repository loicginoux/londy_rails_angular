# This routing directive tells Angular about the default
# route for our application. The term "otherwise" here
# might seem somewhat awkward, but it will make more
# sense as we add more routes to our application.
window.londy.config(["$stateProvider", "$urlRouterProvider", ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise("/projects");
  $stateProvider.state("projects",
    url: "/projects"
    views:
      sidebar: 
        templateUrl: "/assets/projects.html"
        controller: "ProjectListCtrl"
      mainContent: 
        templateUrl: "/assets/project_tasks.html"
        controller: "taskListCtrl" 
  ).state("projects.show",
    url: "/:id"
    views:
      sidebar: 
        templateUrl: "/assets/projects.html"
        controller: "ProjectListCtrl"
      mainContent: 
        templateUrl: "/assets/project_tasks.html"
        controller: "taskListCtrl" 
  ).state("users",
    url: "/users"
    views:
      sidebar: 
        templateUrl: "/assets/users.html"
        controller: "TeamListCtrl"
      mainContent: 
        templateUrl: "/assets/user_tasks.html"
        controller: "taskListCtrl"
  ).state("profile"
    url: "/profile",
    views:
      sidebar: 
        templateUrl: "/assets/profile_menu.html"
        controller: "editAccountNavCtrl"
      mainContent: {}
  )
]).run(() -> console.log('only run on first page load'))




window.londy.config(['$httpProvider', ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken
])

window.londy.config((RestangularProvider) ->
  RestangularProvider.setBaseUrl('/api')
  RestangularProvider.setErrorInterceptor((error) -> console.log(error))
)
