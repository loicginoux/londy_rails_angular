window.londy.controller 'MainCtrl', ['$scope',  "Restangular", "sharedProps", ($scope,  Restangular, sharedProps) ->
  $scope.setTab = (tabName) ->
    $scope.selectedTab = tabName
    sharedProps.selectedTab = tabName
  $scope.setTab("projects")
]

window.londy.controller 'ProjectListCtrl', ['$scope',  "Restangular","sharedProps","$location",  ($scope,  Restangular, sharedProps, $location) ->
  serverProjects = Restangular.one('teams', window.gon.params.id).all('projects')
  $scope.projects = serverProjects.getList().$object
  
  $scope.editedProject = null
  $scope.newProject = ''

  $scope.$watch( (()-> sharedProps.selectedTab) , (newVal, oldVal, scope) -> 
    console.log "ProjectListCtrl:", newVal
    $scope.selectedTab = newVal
  ,true) 

  $scope.selectProject = (proj) -> 
    console.log "select project: ", proj
    $scope.selectedProject = proj
    sharedProps.selectedProject = proj
    $location.path( "/projects/" + proj.id );
    console.log($location.path());


  $scope.addProject = () -> 
    console.log "add project"
    newProj = $scope.newProject.trim()
    if newProj.length == 0
      return
    serverProjects.post({name: newProj}).then((savedProj)->
      $scope.projects.push(savedProj)
    )
    $scope.newProject = ''


  $scope.editProject = (proj) -> 
    console.log "edit proj", proj
    $scope.editedProject = proj
    $scope.originalProject = angular.extend({}, proj)

  $scope.deleteProject = (proj) -> 
    console.log("delete:",proj)
    $scope.editedProject = null
    $scope.originalProject.remove().then(()->
      $scope.projects = _.without($scope.projects, proj)
    )

  $scope.save = (proj) -> 
    console.log("save:",proj)
    proj.name = proj.name.trim()
    if (!proj.name) 
      $scope.deleteProject(proj)
    proj.put()
    $scope.editedProject = null

  
  $scope.onKeyDown = (event, proj) -> 
    console.log("onKeyDown:", event.keyCode, proj, $scope.originalProject)
    $scope.save(proj) if event.keyCode == 13
    return if event.keyCode != 27
    $scope.projects[$scope.projects.indexOf(proj)] = $scope.originalProject
    $scope.editedProject = null

]



window.londy.controller 'TeamListCtrl', ['$scope',  "Restangular", "sharedProps", ($scope,  Restangular, sharedProps) ->
  serverUsers = Restangular.one('teams', window.gon.params.id).all('users')
  $scope.users = serverUsers.getList().$object
  $scope.editedUser = null
  $scope.newUser = ''

  $scope.$watch( (()-> sharedProps.selectedTab), (newVal, oldVal, scope) -> 
    console.log newVal
    $scope.selectedTab = newVal
  ,true) 

  $scope.addUser = () -> 
    console.log "add user"
    newEmail = $scope.newEmail.trim()
    if newEmail.length == 0
      return
    serverUsers.post({email: newEmail})

  $scope.selectUser = (u) -> 
    $scope.selectedUser = u
    sharedProps.selectedUser = u
]

window.londy.controller 'editAccountNavCtrl', ['$scope',  "Restangular","sharedProps",  ($scope,  Restangular, sharedProps) ->
  $scope.$watch( (()-> sharedProps.selectedTab), (newVal, oldVal, scope) -> 
    console.log newVal
    $scope.selectedTab = newVal
  ,true) 
]

window.londy.controller 'taskListCtrl', ['$scope',  "Restangular","sharedProps", "$location", "$routeParams", ($scope,  Restangular, sharedProps, $location, $routeParams) ->
  $scope.selectedProject = sharedProps.selectedProject
  $scope.tasks = []
  $scope.editedTask = null
  $scope.newTask = ''
  console.log("tasks for proj:",$scope.selectedProject)
  serverTasks = null
  debugger
  $scope.$watch( (()-> sharedProps.selectedProject), (newVal, oldVal, scope) -> 
    return if !newVal
    console.log("changed tasks for proj:",newVal)
    $scope.selectedProject = newVal
    console.log("tasks for proj:",$scope.selectedProject)
    serverTasks = Restangular.one('teams', window.gon.params.id).one('projects', newVal.id).all('tasks')
    $scope.tasks = serverTasks.getList().$object
  ,true) 

  $scope.addTask = () -> 
    debugger
    console.log "add"
    newT = $scope.newTask.trim()
    if newT.length == 0
      return
    serverTasks.post({content: newT, project_id: $scope.selectedProject.id}).then((savedObj)->
      $scope.tasks.push(savedObj)
    )
    $scope.newTask = ''
]